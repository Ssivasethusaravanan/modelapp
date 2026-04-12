import { test, expect } from '@playwright/test';

test.describe('Authentication and Security', () => {
  test('unauthenticated users should be kicked to login page', async ({ page }) => {
    // Attempt to access the protected dashboard directly
    await page.goto('/');

    // The middleware should instantly redirect us to the login page
    await expect(page).toHaveURL(/.*\/login/);

    // Verify the login page header is visible
    await expect(page.locator('h1')).toContainText('Welcome Back');
  });

  test('login form should validate inputs correctly', async ({ page }) => {
    // Go to login page
    await page.goto('/login');
    
    // Click the submit button without filling fields
    await page.getByRole('button', { name: 'Sign In' }).click();

    // Verify Zod validation errors immediately appear underneath the fields
    await expect(page.getByText('Please enter a valid email address')).toBeVisible();
    await expect(page.getByText('Password must be at least 6 characters')).toBeVisible();
  });
});
