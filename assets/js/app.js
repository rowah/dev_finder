// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let Hooks = {};

Hooks.ThemeSwitcher = {
  mounted() {
    //ensure correct div is shown when the LiveView is initially mounted
    this.HandleThemeChange();
  },

  HandleThemeChange() {
    const savedTheme = localStorage.getItem("theme");
    if (savedTheme) {
      this.setTheme(savedTheme);
    } else {
      this.setTheme("lightMode");
    }
    this.updateDivVisibility(savedTheme);
  },
  setTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme);
    localStorage.setItem("theme", theme);
    this.pushEvent("update_theme", { theme: theme }); // Send the theme to LiveView
  },

  updateDivVisibility(theme) {
    const lightDiv = document.querySelector(".light-div");
    const darkDiv = document.querySelector(".dark-div");
    if (theme === "lightMode") {
      lightDiv.classList.remove("hidden");
      darkDiv.classList.add("hidden");
    } else {
      lightDiv.classList.add("hidden");
      darkDiv.classList.remove("hidden");
    }
  },
  updated() {
    //Re-apply theme when liveView content changes
    const savedTheme = localStorage.getItem("theme");
    this.updateDivVisibility(savedTheme);
  },
};
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
