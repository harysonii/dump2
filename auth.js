export default defineNuxtRouteMiddleware((to, _from) => {
  const user = useSupabaseUser();
  if (!user.value) {
    useCookie("redirect", { path: "/" }).value = to.fullPath;
    return navigateTo("/login");
  }
});
