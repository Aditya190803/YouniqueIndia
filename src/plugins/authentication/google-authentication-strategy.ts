import { AuthenticationStrategy, ExternalAuthenticationService, Injector, RequestContext, User } from '@vendure/core';
import { OAuth2Client } from 'google-auth-library';
import { DocumentNode } from 'graphql';
import gql from 'graphql-tag';

export interface GoogleAuthData {
    token: string;
}

export class GoogleAuthenticationStrategy implements AuthenticationStrategy<GoogleAuthData> {
    readonly name = 'google';

    private client: OAuth2Client;
    private externalAuthenticationService: ExternalAuthenticationService;

    constructor() {
        this.client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
    }

    init(injector: Injector) {
        this.externalAuthenticationService = injector.get(ExternalAuthenticationService);
    }

    defineInputType(): DocumentNode {
        return gql`
            input GoogleAuthInput {
                token: String!
            }
        `;
    }

    async authenticate(ctx: RequestContext, data: GoogleAuthData): Promise<User | false> {
        try {
            const ticket = await this.client.verifyIdToken({
                idToken: data.token,
                audience: process.env.GOOGLE_CLIENT_ID,
            });

            const payload = ticket.getPayload();
            if (!payload) {
                console.error('Google authentication: No payload received');
                return false;
            }

            const { email, name, sub: googleId, email_verified } = payload;

            if (!email) {
                console.error('Google authentication: No email in payload');
                return false;
            }

            // Check if user exists, if not create one
            const user = await this.externalAuthenticationService.findCustomerUser(ctx, this.name, googleId);
            if (user) {
                console.log(`Google authentication: User ${email} already exists`);
                return user;
            }

            // Create new user with Google data
            const newUser = await this.externalAuthenticationService.createCustomerAndUser(ctx, {
                strategy: this.name,
                externalIdentifier: googleId,
                verified: email_verified || false,
                emailAddress: email,
                firstName: name?.split(' ')[0] || '',
                lastName: name?.split(' ').slice(1).join(' ') || '',
            });

            console.log(`Google authentication: Created new user ${email} with Google ID ${googleId}`);
            return newUser;
        } catch (error) {
            console.error('Google authentication error:', error);
            return false;
        }
    }
}
