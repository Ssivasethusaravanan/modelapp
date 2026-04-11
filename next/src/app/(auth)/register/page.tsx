'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { TrendingUp, User, Mail, Lock, Loader2, UserPlus } from 'lucide-react';
import { cn } from '@/lib/utils';
import Link from 'next/link';

const registerSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Please enter a valid email address'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
});

type RegisterFormValues = z.infer<typeof registerSchema>;

export default function RegisterPage() {
  const router = useRouter();
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<RegisterFormValues>({
    resolver: zodResolver(registerSchema),
  });

  const onSubmit = async (data: RegisterFormValues) => {
    setError(null);
    try {
      const response = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        const result = await response.json();
        throw new Error(result.message || 'Registration failed');
      }

      setSuccess(true);
      setTimeout(() => router.push('/login'), 2000);
    } catch (err: any) {
      setError(err.message);
    }
  };

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-6 relative overflow-hidden">
      {/* Background Gradients */}
      <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-secondary/15 blur-[150px] rounded-full -mr-[300px] -mt-[300px]" />
      <div className="absolute bottom-0 left-0 w-[400px] h-[400px] bg-primary/20 blur-[120px] rounded-full -ml-[200px] -mb-[200px]" />

      <div className="w-full max-w-[440px] z-10 animate-in fade-in zoom-in-95 duration-500">
        <div className="flex flex-col items-center mb-10">
          <div className="bg-secondary p-3 rounded-2xl mb-4 shadow-xl shadow-secondary/20 font-bold">
            <TrendingUp className="text-white w-8 h-8" />
          </div>
          <h1 className="text-3xl font-bold tracking-tight text-white mb-2">Create Account</h1>
          <p className="text-slate-400">Join the elite team management platform</p>
        </div>

        <div className="glass rounded-[32px] p-10 border border-white/10 shadow-2xl">
          {success ? (
            <div className="text-center py-8 space-y-4 animate-in zoom-in duration-500">
              <div className="bg-green-500/20 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <UserPlus className="text-green-500 w-8 h-8" />
              </div>
              <h2 className="text-2xl font-bold text-white">Success!</h2>
              <p className="text-slate-400">Your account has been created. Redirecting to login...</p>
            </div>
          ) : (
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
              {error && (
                <div className="bg-red-500/10 border border-red-500/20 text-red-500 px-4 py-3 rounded-xl text-sm">
                  {error}
                </div>
              )}

              <div className="space-y-1">
                <label className="text-sm font-semibold text-slate-300 ml-1">Full Name</label>
                <div className="relative group">
                  <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 group-focus-within:text-secondary transition-colors" />
                  <input
                    {...register('name')}
                    placeholder="John Doe"
                    className={cn(
                      "w-full bg-white/5 border border-white/10 rounded-2xl py-3.5 pl-12 pr-4 text-white placeholder:text-slate-600 focus:outline-none focus:border-secondary/50 focus:ring-4 focus:ring-secondary/10 transition-all",
                      errors.name && "border-red-500/50"
                    )}
                  />
                </div>
                {errors.name && <p className="text-xs text-red-500 ml-1 mt-1">{errors.name.message}</p>}
              </div>

              <div className="space-y-1">
                <label className="text-sm font-semibold text-slate-300 ml-1">Email Address</label>
                <div className="relative group">
                  <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 group-focus-within:text-secondary transition-colors" />
                  <input
                    {...register('email')}
                    type="email"
                    placeholder="name@company.com"
                    className={cn(
                      "w-full bg-white/5 border border-white/10 rounded-2xl py-3.5 pl-12 pr-4 text-white placeholder:text-slate-600 focus:outline-none focus:border-secondary/50 focus:ring-4 focus:ring-secondary/10 transition-all",
                      errors.email && "border-red-500/50"
                    )}
                  />
                </div>
                {errors.email && <p className="text-xs text-red-500 ml-1 mt-1">{errors.email.message}</p>}
              </div>

              <div className="space-y-1">
                <label className="text-sm font-semibold text-slate-300 ml-1">Password</label>
                <div className="relative group">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500 group-focus-within:text-secondary transition-colors" />
                  <input
                    {...register('password')}
                    type="password"
                    placeholder="••••••••"
                    className={cn(
                      "w-full bg-white/5 border border-white/10 rounded-2xl py-3.5 pl-12 pr-4 text-white placeholder:text-slate-600 focus:outline-none focus:border-secondary/50 focus:ring-4 focus:ring-secondary/10 transition-all",
                      errors.password && "border-red-500/50"
                    )}
                  />
                </div>
                {errors.password && <p className="text-xs text-red-500 ml-1 mt-1">{errors.password.message}</p>}
              </div>

              <button
                disabled={isSubmitting}
                type="submit"
                className="w-full bg-secondary hover:bg-secondary/90 text-white font-bold py-4 rounded-2xl shadow-xl shadow-secondary/20 flex items-center justify-center gap-2 group transition-all active:scale-[0.98] disabled:opacity-70"
              >
                {isSubmitting ? (
                  <Loader2 className="w-5 h-5 animate-spin" />
                ) : (
                  <>
                    <span>Create Account</span>
                    <UserPlus className="w-5 h-5 group-hover:scale-110 transition-transform" />
                  </>
                )}
              </button>
            </form>
          )}

          {!success && (
            <div className="mt-8 text-center">
              <p className="text-slate-400 text-sm">
                Already have an account?{' '}
                <Link href="/login" className="text-secondary font-bold hover:text-accent transition-colors">
                  Sign In
                </Link>
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
