// Sets up a channel to JS-interop with Flutter
(function () {
   "use strict"
   // This function will be called from Flutter when it prepares the JS-interop
   // 잘봐라.. 이함수가 초기에 실행되면 window 객체에 _stateSet 프로퍼티에 해당 함수를 연결해 놓는다. 아직 실행된게 아니다. 
   window._stateSet = function () {
      // This is done for handler callback to be updated from Flutter as well as HTML
      window._log_hello = function () {
         console.log('Hello from Flutter!!'); // DONE [check] 이문장이 나오는지..
      };
      _log_hello(); // 이렇게 실행할 수 도 있구나... 
      // This state of the Flutter app, see class 
      let appState = window._appState; // 이제 자바스크립트에서 dart 에서 내보낸 javascript 객체를 사용할 수 있네.. 

      // Get the input box i.e 'value'
      let valueField = document.querySelector("#value");
      let updateState = function () {
         valueField.value = appState.count;
      }
      // Register a callback to update the HTML field from Flutter
      appState.addHandler(updateState); // 이렇게 함수를 등록한다. 

      // Render the first value (0)
      updateState();

      // Get the increment button
      let incrementButton = document.querySelector("#increment");
      incrementButton.addEventListener("click", (event) => {
         appState.increment();
      });

      // Get the google button
      let googleButton = document.querySelector("#google");
      googleButton.addEventListener("click", (event) => {
         appState.getValue('google.com');
      });

      // Get the flutter button
      let flutterButton = document.querySelector("#flutter");
      flutterButton.addEventListener("click", (event) => {
         appState.getValue('flutter.dev');
      });

      // Get the show/hide button
      let showHideButton = document.querySelector("#btnVisible");
      showHideButton.addEventListener("click", (event) => {
         var res = showHide(); // CHECK _ 를 이용해서 이름 변경해보자.
         appState.showHideValue(res); // Function present inside of Flutter
      });

      // changes the show/hide button's text
      let updateText = function () {
         showHideButton.value = appState.showHideNav;
      }

      // Register a callback to update the HTML field from Flutter
      // TODOS 콜백함수를 넘겨주어서 Stream 을 사용하지 않고 콜백함수가 실행되도록 해보자..
      appState.addHandler(updateText); // 이렇게 함수를 등록한다.  여기서 함수를 또 등록해주었네..
      updateText(); // 초기값을 위해 실행

      // Show/Hide div
      function showHide() {
         var x = document.getElementById("nav_controls");
         var shown = false;
         if (x.style.display === "none") {
            x.style.display = "block";
            shown = true;
         } else {
            x.style.display = "none";
            shown = false;
         }
         return shown;
      }

   };
}()
);