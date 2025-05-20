document.addEventListener("turbo:load", () => {
  const toggles = document.querySelectorAll(".theme-controller");

  toggles.forEach(toggle => {
    toggle.addEventListener("change", () => {
      const themes = toggle.dataset.toggleTheme?.split(",") || ["light", "cupcake"];
      const activeClass = toggle.dataset.actClass || "ACTIVE";

      if (toggle.checked) {
         console.log('theme toggle is checked');
         document.documentElement.setAttribute("data-theme", themes[1] || "cupcake");
         toggle.classList.add(activeClass);
      } else {
         console.log('theme toggle is not checked');
         document.documentElement.setAttribute("data-theme", themes[0] || "light");
         toggle.classList.remove(activeClass);
      }
    });
  });
});

