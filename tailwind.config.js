/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.{css,scss}",
    "./app/javascript/**/*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
  ],
}
