document.addEventListener("DOMContentLoaded", () => {
  const btn = document.querySelector(".theme-toggle");
  btn.onclick = () => document.body.classList.toggle("dark");
});
