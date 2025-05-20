// tailwind.config.js
// // import defaultTheme    from 'tailwindcss/defaultTheme'
import aspectRatio     from '@tailwindcss/aspect-ratio'
import typography      from '@tailwindcss/typography'
import containerQueries from '@tailwindcss/container-queries'

/** @type {import('tailwindcss').Config} */
export default {
  theme: {
    extend: {
      fontFamily: {
// //         sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        jost: ['Jost', 'sans-serif'],
      },
      animation: {
        fadeOut: 'fadeOut 2.5s ease-out forwards',
      },
    },
  },
  plugins: [
    aspectRatio,
    typography,
    containerQueries,
  ],
}