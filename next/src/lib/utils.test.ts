import { describe, it, expect } from 'vitest';
import { cn } from './utils';

describe('Utility Functions: cn (Tailwind Class Merger)', () => {
  it('should cleanly merge standard tailwind classes', () => {
    const result = cn('text-white', 'font-bold', 'p-4');
    expect(result).toBe('text-white font-bold p-4');
  });

  it('should resolve tailwind specificity conflicts correctly', () => {
    // If you apply two conflicting background colors, the last one should win
    const result = cn('bg-red-500', 'bg-blue-500');
    expect(result).toBe('bg-blue-500'); 
  });

  it('should ignore falsey values in conditional rendering', () => {
    const isActive = true;
    const isError = false;
    const result = cn('p-4', isActive && 'bg-primary', isError && 'text-red-500');
    expect(result).toBe('p-4 bg-primary');
  });
});
