import { GoogleAuthenticationStrategy } from './google-authentication-strategy';
import { ExternalAuthenticationService, Injector, RequestContext, User } from '@vendure/core';
import { OAuth2Client } from 'google-auth-library';

describe('GoogleAuthenticationStrategy', () => {
    let strategy: GoogleAuthenticationStrategy;
    let mockExternalAuthService: Partial<ExternalAuthenticationService>;
    let mockInjector: Partial<Injector>;
    let mockOAuth2Client: Partial<OAuth2Client>;

    beforeEach(() => {
        process.env.GOOGLE_CLIENT_ID = 'test-client-id';
        strategy = new GoogleAuthenticationStrategy();
        mockExternalAuthService = {
            findCustomerUser: jest.fn().mockResolvedValue(null),
            createCustomerAndUser: jest.fn().mockResolvedValue({ id: 1, identifier: 'test@example.com' }),
        };
        mockInjector = {
            get: jest.fn().mockImplementation((service) => {
                if (service === ExternalAuthenticationService) return mockExternalAuthService;
            }),
        };
        mockOAuth2Client = {
            verifyIdToken: jest.fn().mockResolvedValue({
                getPayload: () => ({
                    email: 'test@example.com',
                    sub: 'google-id',
                    email_verified: true,
                    given_name: 'Test',
                    family_name: 'User',
                }),
            }),
        };
        // @ts-ignore
        strategy.oauthClient = mockOAuth2Client;
        // @ts-ignore
        strategy.init(mockInjector);
    });

    it('should authenticate and create a new user if not found', async () => {
        const ctx = {} as RequestContext;
        const data = { token: 'test-token' };
        const user = await strategy.authenticate(ctx, data);
        expect(user).toBeDefined();
        expect(mockExternalAuthService.createCustomerAndUser).toHaveBeenCalled();
    });

    it('should return existing user if found', async () => {
        (mockExternalAuthService.findCustomerUser as jest.Mock).mockResolvedValueOnce({ id: 2, identifier: 'existing@example.com' });
        const ctx = {} as RequestContext;
        const data = { token: 'test-token' };
        const user = await strategy.authenticate(ctx, data);
        expect(user).toEqual({ id: 2, identifier: 'existing@example.com' });
    });

    it('should return false if payload is missing email', async () => {
        (mockOAuth2Client.verifyIdToken as jest.Mock).mockResolvedValueOnce({ getPayload: () => ({}) });
        const ctx = {} as RequestContext;
        const data = { token: 'test-token' };
        const user = await strategy.authenticate(ctx, data);
        expect(user).toBe(false);
    });
});
