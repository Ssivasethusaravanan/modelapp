import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: "#6366F1",
          foreground: "#FFFFFF",
        },
        secondary: {
          DEFAULT: "#A855F7",
          foreground: "#FFFFFF",
        },
        accent: {
          DEFAULT: "#22D3EE",
          foreground: "#0F172A",
        },
        background: "#0F172A",
        surface: "#1E293B",
        error: "#EF4444",
        slate: {
          400: "#94A3B8",
          600: "#475569",
        }
      },
      backgroundImage: {
        "gradient-radial": "radial-gradient(var(--tw-gradient-stops))",
        "gradient-conic": "conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))",
        "midnight-gradient": "linear-gradient(135deg, #0F172A 0%, #1E293B 100%)",
      },
    },
  },
  plugins: [],
};
export default config;
