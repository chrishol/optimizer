module.exports = {
  future: {
    // removeDeprecatedGapUtilities: true,
    // purgeLayersByDefault: true,
  },
  purge: [],
  theme: {
    container: {
      center: true,
    },
    extend: {
      spacing: {
        '128': '32rem'
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/custom-forms')
  ],
}
