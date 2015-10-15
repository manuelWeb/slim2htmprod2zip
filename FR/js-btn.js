(function() {
  // lien global
  var evtFirst_Link = document.getElementById('evtFirst_Link');

  function loopfct() {
    if (url_bt) {
      document.location = url_bt;
    }
  }
  try {
    if (evtFirst_Link) {
      evtFirst_Link.style.cursor = 'pointer';

      var evtFirst_Link_tab = evtFirst_Link.children,
        evtFirst_Link_tabLength = evtFirst_Link_tab.length;
      for (var i = 0; i < evtFirst_Link_tabLength; i++) {
        if (evtFirst_Link_tab[i].className == 'js-btn') {
          var url_bt = evtFirst_Link_tab[i].getAttribute('href'),
            track = evtFirst_Link_tab[i].getAttribute('onclick');
          // console.log(url_bt+"\n"+track)
          // ajout ga sur toute la zone
          evtFirst_Link.setAttribute('onclick', track);
          evtFirst_Link.onclick = loopfct;
        }
      } 
    } 

  } catch (e) {
    if (console) {
      console.log(e);
    }
  }

})(); // end IEF
