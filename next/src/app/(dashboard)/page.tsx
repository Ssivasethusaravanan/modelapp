// src/app/(dashboard)/page.tsx
import { serverApi } from '@/lib/api-client';
import { cookies } from 'next/headers';
import { 
  Mail, 
  Fingerprint, 
  Calendar, 
  Clock, 
  ArrowUpRight 
} from 'lucide-react';
import { cn } from '@/lib/utils';

async function getHomeData() {
  const cookieStore = await cookies();
  const token = cookieStore.get('access_token')?.value;

  if (!token) return null;

  try {
    const response = await fetch(`${process.env.BACKEND_API_URL || 'https://teammanagementbackend.projectece5566.workers.dev'}/api/home`, {
      headers: {
        'Authorization': `Bearer ${token}`
      },
      next: { revalidate: 60 } // Revalidate every minute
    });

    if (!response.ok) return null;
    return response.json();
  } catch (error) {
    console.error('Fetch home data error:', error);
    return null;
  }
}

export default async function DashboardPage() {
  const homeData = await getHomeData();

  if (!homeData) {
    return (
      <div className="flex flex-col items-center justify-center h-full text-slate-400">
        <p>Failed to load dashboard data. Please try again later.</p>
      </div>
    );
  }

  const { user, message } = homeData;

  return (
    <div className="max-w-5xl animate-in fade-in duration-700 slide-in-from-bottom-4">
      {/* Welcome Header */}
      <div className="mb-12">
        <p className="text-accent font-medium mb-1 tracking-wide opacity-80">
          {message || 'GOOD MORNING,'}
        </p>
        <h1 className="text-5xl lg:text-6xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-accent to-secondary py-2">
          {user.name}
        </h1>

        <div className="flex gap-6 mt-6">
          <div className="flex items-center gap-2 text-xs text-slate-400">
            <Clock className="w-3.5 h-3.5" />
            <span>Last login: {user.lastLogin || 'Just now'}</span>
          </div>
          <div className="flex items-center gap-2 text-xs text-slate-400">
            <Calendar className="w-3.5 h-3.5" />
            <span>Member since: {user.createdAt || 'N/A'}</span>
          </div>
        </div>
      </div>

      {/* Account Details Card */}
      <div className="glass rounded-[32px] p-8 lg:p-10 relative overflow-hidden group hover:border-primary/30 transition-all duration-500">
        <div className="flex justify-between items-start mb-10">
          <div>
            <h2 className="text-xs font-bold text-accent/50 tracking-[2px] mb-2">ACCOUNT DETAILS</h2>
            <div className="h-1 w-12 bg-primary/40 rounded-full" />
          </div>
          <div className="p-3 bg-primary/10 rounded-2xl group-hover:bg-primary/20 transition-colors">
            <Fingerprint className="text-primary w-6 h-6" />
          </div>
        </div>

        <div className="space-y-8">
          <InfoRow 
            icon={Mail} 
            label="Email Address" 
            value={user.email} 
          />
          <div className="h-px bg-white/5" />
          <InfoRow 
            icon={Fingerprint} 
            label="User ID" 
            value={user.id} 
          />
          <div className="h-px bg-white/5" />
          <InfoRow 
            icon={ArrowUpRight} 
            label="Account Status" 
            value="Professional (Active)" 
            highlight 
          />
        </div>
      </div>
    </div>
  );
}

function InfoRow({ 
  icon: Icon, 
  label, 
  value, 
  highlight = false 
}: { 
  icon: any, 
  label: string, 
  value: string, 
  highlight?: boolean 
}) {
  return (
    <div className="flex items-center gap-6 group/row">
      <div className="p-3 bg-white/5 rounded-xl group-hover/row:bg-primary/20 transition-colors duration-300">
        <Icon className={cn("w-5 h-5", highlight ? "text-accent" : "text-slate-400")} />
      </div>
      <div>
        <p className="text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-1">{label}</p>
        <p className={cn(
          "text-lg font-medium",
          highlight ? "text-accent underline decoration-accent/20 underline-offset-4" : "text-white"
        )}>
          {value}
        </p>
      </div>
    </div>
  );
}
