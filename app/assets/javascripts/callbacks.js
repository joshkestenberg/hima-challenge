var Callbacks = (function(){

  function disableSubmit() {
    $('.main--home--search--input').val('')
    $('[data-submit]').removeClass('main--home--search--button--enabled')
    $('[data-submit]').prop('disabled', true)
    $('[data-submit]').submit(function(){
      event.preventDefault()
    })
  }

   function enableSubmit(){
    $('[data-submit]').addClass('main--home--search--button--enabled')
    $('[data-submit]').prop('disabled', false)
  }

  var clearResults = function(){
    $('.main--home--results').slideUp(600, function(){
      $('.main--home--results').empty();
    });
    disableSubmit();
  }

  function showResults(punchCards, punchButton, animate){
    var results = $('.main--home--results')

    if (animate === 'true'){
      results.hide()
      results.html(punchCards).append(punchButton)
      results.slideDown(600)
    } else{
      results.html(punchCards).append(punchButton)
    }
  }

  return {
    disableSubmit: disableSubmit,
    enableSubmit: enableSubmit,
    clearResults: clearResults,
    showResults: showResults,
  }

})();
