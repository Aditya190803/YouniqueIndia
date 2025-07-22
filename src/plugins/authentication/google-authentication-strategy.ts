import { AuthenticationStrategy, ExternalAuthenticationService, Injector, RequestContext, User } from '@vendure/core';
import { OAuth2Client } from 'google-auth-library';
import { DocumentNode } from 'graphql';
import gql from 'graphql-tag';

export interface GoogleAuthData {
    token: string;
}

export class GoogleAuthenticationStrategy implements AuthenticationStrategy<GoogleAuthData> {
    readonly name = 'google';
    private externalAuthenticationService: ExternalAuthenticationService;
    private googleClientId: string;
    private oauthClient: OAuth2Client;

    constructor() {
        this.googleClientId = process.env.GOOGLE_CLIENT_ID || '';
        this.oauthClient = new OAuth2Client(this.googleClientId);
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
            const ticket = await this.oauthClient.verifyIdToken({
                idToken: data.token,
                audience: this.googleClientId,
            });
            const payload = ticket.getPayload();
            if (!payload || !payload.email) {
                return false;
            }
            const { email, sub: googleId, email_verified, given_name, family_name, name } = payload;
            // Check if user exists, if not create one
            let user = await this.externalAuthenticationService.findCustomerUser(ctx, this.name, googleId);
            if (user) {
                return user;
            }
            // Create new user with Google data
            user = await this.externalAuthenticationService.createCustomerAndUser(ctx, {
                strategy: this.name,
                externalIdentifier: googleId,
                verified: email_verified || false,
                emailAddress: email,
                firstName: given_name || name?.split(' ')[0] || '',
                lastName: family_name || name?.split(' ').slice(1).join(' ') || '',
            });
            return user;
        } catch (error) {
            console.error('Google authentication error:', error);
            return false;
        }
    }
} 