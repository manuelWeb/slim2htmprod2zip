/* jshint camelcase:true */
(function() {
  var
    count = 0,
    img = $('.animated-stars')[0];

  img.style.display = 'none';

  function anime(img) {
    count += 1;
    if (count < 7) {
      img.style.display == 'none' ? $(img).fadeIn(1000).queue(function() {
        recursive();
      }) : $(img).fadeOut(1000).queue(function() {
        recursive();
      });
    } else {
      // console.log('stop' + ' ' + count);/*var n = $(img).queue();console.log(n.length)// return false;*/
      count = 0;
      runFct();
    }
  }

  function runFct() {
    setTimeout(function() {
      anime(img);
    }, 2000);
  }

  function recursive() {
    $(img).clearQueue();
    setTimeout(function() {
      anime(img);
    }, 100);
  }

  runFct();
})();