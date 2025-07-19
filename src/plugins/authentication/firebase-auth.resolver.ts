import { Args, Mutation, Resolver } from '@nestjs/graphql';
import { Ctx, RequestContext, Allow, Permission } from '@vendure/core';
import { FirebaseAuthenticationStrategy } from './firebase-authentication-strategy';

@Resolver()
export class FirebaseAuthResolver {
    constructor(private firebaseStrategy: FirebaseAuthenticationStrategy) {}

    @Mutation()
    @Allow(Permission.Owner)
    async authenticateWithFirebase(
        @Ctx() ctx: RequestContext,
        @Args('input') input: { token: string }
    ) {
        try {
            const user = await this.firebaseStrategy.authenticate(ctx, { token: input.token });
            
            if (user) {
                // Return success response
                return {
                    __typename: 'CurrentUser',
                    id: user.id,
                    identifier: user.identifier,
                    verified: user.verified,
                    customFields: user.customFields,
                };
            } else {
                // Return error response
                return {
                    __typename: 'AuthenticationError',
                    errorCode: 'INVALID_CREDENTIALS',
                    message: 'Invalid Firebase token',
                };
            }
        } catch (error) {
            return {
                __typename: 'AuthenticationError',
                errorCode: 'AUTHENTICATION_ERROR',
                message: error instanceof Error ? error.message : 'Authentication failed',
            };
        }
    }
} 