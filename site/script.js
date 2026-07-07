const root = document.documentElement;
const toggle = document.querySelector(".theme-toggle");
const toggleIcon = toggle.querySelector("span");
const themeColor = document.querySelector('meta[name="theme-color"]');
const systemTheme = window.matchMedia("(prefers-color-scheme: dark)");

function storedTheme() {
  try {
    return localStorage.getItem("theme");
  } catch {
    return null;
  }
}

function currentTheme() {
  return root.dataset.theme || (systemTheme.matches ? "dark" : "light");
}

function updateThemeControl() {
  const isDark = currentTheme() === "dark";
  toggle.setAttribute("aria-pressed", String(isDark));
  toggle.setAttribute("aria-label", `Switch to ${isDark ? "light" : "dark"} mode`);
  toggleIcon.textContent = isDark ? "☀" : "☾";
  themeColor.setAttribute("content", isDark ? "#0e1714" : "#f4f0e8");
}

const savedTheme = storedTheme();
if (savedTheme === "light" || savedTheme === "dark") {
  root.dataset.theme = savedTheme;
}

toggle.addEventListener("click", () => {
  const theme = currentTheme() === "dark" ? "light" : "dark";
  root.dataset.theme = theme;

  try {
    localStorage.setItem("theme", theme);
  } catch {
    // The selected theme still applies for the current page view.
  }

  updateThemeControl();
});

systemTheme.addEventListener("change", () => {
  if (!storedTheme()) updateThemeControl();
});

updateThemeControl();
document.getElementById("year").textContent = new Date().getFullYear();
