const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        helvetica: ['Helvetica'],
        ariel: ['Ariel'],
        jost: ['Jost', 'sans-serif']
      },
      animation: {
        fadeOut: 'fadeOut 2.5s ease-out forwards',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    //require("daisyui"), // comment out for Docker
  ],
  daisyui: {
    themes: ["light", "dark", "cupcake"],
  },
}
