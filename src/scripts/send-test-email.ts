import 'dotenv/config';
import { Resend } from 'resend';

function parseArg(name: string): string | undefined {
  const i = process.argv.findIndex(a => a === `--${name}`);
  if (i !== -1 && process.argv[i + 1]) return process.argv[i + 1];
  const pref = `--${name}=`;
  const arg = process.argv.find(a => a.startsWith(pref));
  return arg ? arg.slice(pref.length) : undefined;
}

async function main() {
  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    console.error('Missing RESEND_API_KEY in environment.');
    process.exit(1);
  }
  const positional = process.argv.find(a => /@/.test(a));
  const to = parseArg('to') || process.env.TEST_EMAIL || positional;
  if (!to) {
    console.error('Provide a recipient with --to you@example.com or set TEST_EMAIL env var.');
    process.exit(1);
  }
  const from = parseArg('from') || process.env.FROM_EMAIL || 'YouniqueIndia <onboarding@resend.dev>';
  const subject = parseArg('subject') || 'Resend test from YouniqueIndia';
  const body = `
    <div style="font-family: system-ui, Arial, sans-serif;">
      <h2>Resend API Test</h2>
      <p>If you received this, Resend API integration works 🎯</p>
      <p><strong>Time:</strong> ${new Date().toISOString()}</p>
    </div>
  `;
  console.log(`Sending test email to ${to} from ${from}...`);
  const resend = new Resend(apiKey);
  const { data, error } = await resend.emails.send({
    from,
    to,
    subject,
    html: body,
  } as any);
  if (error) {
    console.error('Resend error:', error);
    const code = (error as any)?.statusCode;
    const message = (error as any)?.error || (error as any)?.message || '';
    if (code === 403 && /only send testing emails/i.test(String(message))) {
      // Try to extract the allowed sender email from the error message
      const allowedMatch = String(message).match(/\(([^)@\s]+@[^)\s]+)\)/);
      const allowed = allowedMatch?.[1];
      console.error('\nHint: Resend free testing allows sending only to your own account email.');
      if (allowed) {
        console.error(`Try: npm run email:test -- --to ${allowed}`);
      } else {
        console.error('Try: npm run email:test -- --to <your-resend-account-email>');
      }
      console.error('To send to other recipients, verify a domain at https://resend.com/domains');
      console.error('and use a From address at that domain, e.g. --from "YouniqueIndia" <noreply@youniqueindia.com>.');
    }
    process.exit(2);
  }
  console.log('Resend accepted message:', data);
  console.log('Check Resend dashboard and recipient inbox/spam.');
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
