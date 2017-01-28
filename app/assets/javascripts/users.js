/* global $, Stripe */
//Document ready.
$(document).on('turbolinks:load', function(){
  var theForm = $('#pro_form');
  var submitBtn = $('#form-submit-btn');
  
  //Set our stripe public key
  Stripe.setPublishableKey( $('meta[name="stripe-key"]').attr('content') );
  
  //When user clicks form submit btn
  submitBtn.click(function(event){
    
    //prevent default submission behaviour
    event.preventDefault();
    submitBtn.val("Processing").prop('disabled', true);
    
    //Collect credit card fields
    var ccNum = $('#card_number').val(),
        cvcNum = $('#card_code').val(),
        expMonth = $('#card_month').val(),
        expYear = $('#card_year').val();
      
    //use stripe JS library to check for card errors
    var error = false;
    
    //Validate card number
    if (!Stripe.card.validateCardNumber(ccNum)) {
      error=true;
      alert('The credit card appears to be invalid');
    }
     //Validate card number
        if (!Stripe.card.validateCVC(cvcNum)) {
          error=true;
          alert('The CVC number appears to be invalid');
        }
      //Validate card number
        if (!Stripe.card.validateExpiry(expMonth, expYear)) {
          error=true;
          alert('The CVC number appears to be invalid');
        }
        
    if (error){
      //if there are card errors, don't send to stripe
      submitBtn.prop('disabled', false).val("Sign Up");
      } else {
      //Send card information to Stripe
      Stripe.createToken({
       number:  ccNum,
       cvc: cvcNum,
       exp_month: expMonth,
       exp_year: expYear
      }, stripeResponseHandler);
      }
    }

    
    
    
    return false;
  };)
  
  //Stripe will return a card token
  function stripeResponseHandler(status, response){
    //get the token from the response
    var token = response.id;
    //Inject the card token in a hidden field
    theForm.append( $('<input type = "hidden" name = "user[stripe_card_token]">').val(token) );
    
      //submit form to our rails app
      theForm.get(0).submit();
  };

});

