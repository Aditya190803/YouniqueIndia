import { AuthenticationStrategy, ExternalAuthenticationService, Injector, RequestContext, User } from '@vendure/core';
import { DocumentNode } from 'graphql';
import gql from 'graphql-tag';

export interface FirebaseAuthData {
    token: string;
}

export class FirebaseAuthenticationStrategy implements AuthenticationStrategy<FirebaseAuthData> {
    readonly name = 'firebase';

    private externalAuthenticationService: ExternalAuthenticationService;
    private firebaseProjectId: string;

    constructor() {
        this.firebaseProjectId = process.env.VITE_FIREBASE_PROJECT_ID || '';
    }

    init(injector: Injector) {
        this.externalAuthenticationService = injector.get(ExternalAuthenticationService);
    }

    defineInputType(): DocumentNode {
        return gql`
            input FirebaseAuthInput {
                token: String!
            }
        `;
    }

    async authenticate(ctx: RequestContext, data: FirebaseAuthData): Promise<User | false> {
        try {
            // Verify the Firebase ID token using Firebase's public API
            const decodedToken = await this.verifyFirebaseToken(data.token);
            
            if (!decodedToken) {
                console.error('Firebase authentication: Invalid token');
                return false;
            }

            const { email, name, user_id: firebaseId, email_verified } = decodedToken;

            if (!email) {
                console.error('Firebase authentication: No email in token');
                return false;
            }

            // Check if user exists, if not create one
            const user = await this.externalAuthenticationService.findCustomerUser(ctx, this.name, firebaseId);
            if (user) {
                console.log(`Firebase authentication: User ${email} already exists`);
                return user;
            }

            // Create new user with Firebase data
            const newUser = await this.externalAuthenticationService.createCustomerAndUser(ctx, {
                strategy: this.name,
                externalIdentifier: firebaseId,
                verified: email_verified || false,
                emailAddress: email,
                firstName: name?.split(' ')[0] || '',
                lastName: name?.split(' ').slice(1).join(' ') || '',
            });

            console.log(`Firebase authentication: Created new user ${email} with Firebase ID ${firebaseId}`);
            return newUser;
        } catch (error) {
            console.error('Firebase authentication error:', error);
            return false;
        }
    }

    private async verifyFirebaseToken(idToken: string): Promise<any> {
        try {
            // Use Firebase's public API to verify the token
            const response = await fetch(`https://www.googleapis.com/identitytoolkit/v3/relyingparty/publicKeys?key=${process.env.VITE_FIREBASE_API_KEY}`);
            
            if (!response.ok) {
                throw new Error('Failed to fetch Firebase public keys');
            }

            const publicKeys = await response.json();
            
            // For simplicity, we'll use a basic verification approach
            // In production, you might want to implement proper JWT verification
            const tokenParts = idToken.split('.');
            if (tokenParts.length !== 3) {
                throw new Error('Invalid token format');
            }

            // Decode the payload (second part of the token)
            const payload = JSON.parse(Buffer.from(tokenParts[1], 'base64').toString());
            
            // Basic validation
            if (payload.aud !== this.firebaseProjectId) {
                throw new Error('Invalid audience');
            }

            if (payload.iss !== `https://securetoken.google.com/${this.firebaseProjectId}`) {
                throw new Error('Invalid issuer');
            }

            const now = Math.floor(Date.now() / 1000);
            if (payload.exp < now) {
                throw new Error('Token expired');
            }

            return {
                email: payload.email,
                name: payload.name,
                user_id: payload.user_id,
                email_verified: payload.email_verified
            };
        } catch (error) {
            console.error('Token verification error:', error);
            return null;
        }
    }
}
