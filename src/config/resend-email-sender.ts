import { Logger } from '@vendure/core';
import { EmailDetails, EmailSender, EmailTransportOptions } from '@vendure/email-plugin';
import { Resend } from 'resend';

export class ResendEmailSender implements EmailSender {
  protected resend: Resend;

  constructor(apiKey: string) {
    this.resend = new Resend(apiKey);
  }

  async send(email: EmailDetails, _options: EmailTransportOptions): Promise<void> {
    const { error, data } = await this.resend.emails.send({
      to: email.recipient,
      from: email.from,
      subject: email.subject,
      html: email.body,
      cc: email.cc,
      bcc: email.bcc,
      reply_to: email.replyTo,
    } as any);

    if (error) {
      Logger.error((error as any).message ?? String(error), 'ResendEmailSender');
    } else {
      Logger.debug(`Email sent: ${data?.id}`, 'ResendEmailSender');
    }
  }
}
