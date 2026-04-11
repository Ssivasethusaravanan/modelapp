// src/app/(dashboard)/layout.tsx
import { Sidebar } from '@/components/layout/sidebar';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex bg-background h-screen overflow-hidden">
      {/* Sidebar - Desktop */}
      <Sidebar />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col h-full relative">
        {/* Background Gradients for Aesthetics */}
        <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-primary/20 blur-[120px] rounded-full -mr-64 -mt-64 pointer-events-none" />
        <div className="absolute bottom-0 left-0 w-[300px] h-[300px] bg-secondary/10 blur-[100px] rounded-full -ml-32 -mb-32 pointer-events-none" />

        {/* Content Wrapper */}
        <main className="flex-1 overflow-y-auto relative z-10 px-8 py-12 lg:px-12">
          {children}
        </main>
      </div>
    </div>
  );
}
