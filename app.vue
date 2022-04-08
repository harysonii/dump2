<template>
  <div class="flex w-screen h-screen overflow-hidden text-gray-700">
    <!-- Component Start -->
    <Teams class="hidden sm:flex" />
    <Menu class="hidden sm:flex" />
    <slot />
  </div>
  <!-- Component End  -->
</template>
<style scoped>
.group:focus .group-focus\:flex {
  display: flex;
}

.max-w-xs {
  max-width: 20rem;
}
</style>
