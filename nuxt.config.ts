import { defineNuxtConfig } from "nuxt3";

// https://v3.nuxtjs.org/docs/directory-structure/nuxt.config

export default defineNuxtConfig({
  typescript: {
    shim: false,
  },
  buildModules: ["@nuxtjs/tailwindcss", "@nuxtjs/supabase"],
  supabase: {
    url: process.env.SUPABASE_DATABASE_URL,
    key: process.env.SUPABASE_ANON_API_KEY,
    client: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  },
  plugins: [
    // { src: "@/plugins/vee-validate", ssr: false },
    // { src: "@/plugins/editor", ssr: false },
    // { src: "@/plugins/datepicker", ssr: sfalse },
    // "@/plugins/click-outside",
    // "@plugins/vue-js-modal",
    // "@plugins/vue-chat-scroll",
  ],
});
