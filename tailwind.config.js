const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  important: true,
  theme: {
    screens: {
      xs: { max: "475px" },
      tb: { min: "476px", max: "767px" },
      ...defaultTheme.screens,
    },
    backgroundSize: {
      auto: "auto",
      cover: "cover",
      contain: "contain",
    },
    extend: {
      fontFamily: {
        // serif: ["Amiri", ...defaultTheme.fontFamily.serif],
        // cursive: ["Dela Gothic One"],
        // display: ["Averia+Serif+Libre"],
      },
    },
  },
  variants: {
    extend: {
      backgroundColor: ["checked"],
      borderColor: ["checked"],
      inset: ["checked"],
      zIndex: ["hover", "active"],
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // ...
  ],
  // purge: {
  content: [
    `components/**/*.{vue,js}`,
    `layouts/**/*.vue`,
    `pages/**/*.vue`,
    `plugins/**/*.{js,ts}`,
    // `nuxt.config.{js,ts}`,
  ],
  // }
};
