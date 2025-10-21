import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'Gmail',
  auth: {
    user: process.env.EMAIL_USER || 'madhav.soni@bazar.earth',
    pass: process.env.EMAIL_PASSWORD || 'emps muyi tgte evmn'
  }
});

export interface EmailTemplate {
  subject: string;
  html: string;
  text: string;
}

export function createVerificationEmail(code: string): EmailTemplate {
  const subject = 'Verify your email address';
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Email Verification</title>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #6A1B9A; color: white; padding: 20px; text-align: center; }
        .content { padding: 30px; background: #f9f9f9; }
        .code { font-size: 32px; font-weight: bold; color: #6A1B9A; text-align: center; margin: 20px 0; padding: 20px; background: white; border-radius: 8px; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 14px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>Welcome to Bazar Prime</h1>
        </div>
        <div class="content">
          <h2>Verify your email address</h2>
          <p>Thank you for registering! To complete your account setup, please verify your email address using the code below:</p>
          <div class="code">${code}</div>
          <p>This code will expire in 10 minutes.</p>
          <p>If you didn't create an account with us, please ignore this email.</p>
        </div>
        <div class="footer">
          <p>This email was sent from Bazar Prime</p>
        </div>
      </div>
    </body>
    </html>
  `;
  
  const text = `
    Welcome to Bazar Prime
    
    Verify your email address
    
    Thank you for registering! To complete your account setup, please verify your email address using the code below:
    
    ${code}
    
    This code will expire in 10 minutes.
    
    If you didn't create an account with us, please ignore this email.
  `;

  return { subject, html, text };
}

export function createPasswordResetEmail(code: string): EmailTemplate {
  const subject = 'Reset your password';
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Password Reset</title>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #6A1B9A; color: white; padding: 20px; text-align: center; }
        .content { padding: 30px; background: #f9f9f9; }
        .code { font-size: 32px; font-weight: bold; color: #6A1B9A; text-align: center; margin: 20px 0; padding: 20px; background: white; border-radius: 8px; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 14px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>Password Reset</h1>
        </div>
        <div class="content">
          <h2>Reset your password</h2>
          <p>You requested to reset your password. Use the code below to verify your identity:</p>
          <div class="code">${code}</div>
          <p>This code will expire in 10 minutes.</p>
          <p>If you didn't request a password reset, please ignore this email.</p>
        </div>
        <div class="footer">
          <p>This email was sent from Bazar Prime</p>
        </div>
      </div>
    </body>
    </html>
  `;
  
  const text = `
    Password Reset
    
    Reset your password
    
    You requested to reset your password. Use the code below to verify your identity:
    
    ${code}
    
    This code will expire in 10 minutes.
    
    If you didn't request a password reset, please ignore this email.
  `;

  return { subject, html, text };
}

export async function sendEmail(to: string, template: EmailTemplate): Promise<void> {
  try {
    const from = `"${process.env.EMAIL_FROM_NAME || 'Bazar Prime'}" <${process.env.EMAIL_FROM || 'madhav.soni@bazar.earth'}>`;
    await transporter.sendMail({
      from,
      to,
      subject: template.subject,
      html: template.html,
      text: template.text,
    });
    console.log(`Email sent successfully to ${to}`);
  } catch (error) {
    console.error('Error sending email:', error);
    throw new Error('Failed to send email');
  }
}

export function generateVerificationCode(): string {
  return Math.floor(100000 + Math.random() * 900000).toString();
}
