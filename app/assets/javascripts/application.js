// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.remotipart
//= require_tree .
//= require turbolinks


$(document).on('click', '#new_vendor_option', function(e) { 
	if (!document.querySelector("#new_vendor_text_field")) {
		$(".vendor_container").append("<input id='new_vendor_text_field' name='vendor[name]' type='text' placeholder='Enter a vendor name'></input>");
	}
});


$(function() {
	

	
	$("#edit_payment_info_button").on("click", function(e) {
		$(".payment_info :input").attr("disabled", false);
		$(".order_info :input").attr("disabled", true);
		return false;
	})
	
	$("#submit_order_button").on("click", function(e){ 
		var credit_card_number = $("input[name='payment_info[credit_card_number]']").val();
		var credit_card_cvv = $("input[name='payment_info[credit_card_cvv]']").val();
		var credit_card_exp_mm = $("select[name='payment_info[credit_card_exp_mm]']").val();
		var credit_card_exp_yyyy = $("select[name='payment_info[credit_card_exp_yyyy]']").val();
		
		var hidden_ccnumber_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_number]").val(credit_card_number);
		var hidden_cccvv_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_cvv]").val(credit_card_cvv);
		var hidden_ccexpmm_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_exp_mm]").val(credit_card_exp_mm);
		var hidden_ccexpyyyy_input = $("<input>").attr("type", "hidden").attr("name", "credit_card[credit_card_exp_yyyy]").val(credit_card_exp_yyyy);
		
		
		$(".credit_card_inputs").empty();
		$(".credit_card_inputs").append(hidden_ccnumber_input);
		$(".credit_card_inputs").append(hidden_cccvv_input);
		$(".credit_card_inputs").append(hidden_ccexpmm_input);
		$(".credit_card_inputs").append(hidden_ccexpyyyy_input);
	});
	
	
	if ($(".user_info").length) {
		$(".payment_info :input").attr("disabled", true);
	}
	
  
  $(".order_info :input").attr("disabled", true);
	
	
	
	$(".log_in_div").hide();
	
	$(".checkout_sign_up_link").on("click", function(e){
		e.preventDefault();
		$(".user_info_errors").empty();
		$(".sign_up_div").show();
		$(".log_in_div").hide();
	});
	
	$(".checkout_log_in_link").on("click", function(e){
		e.preventDefault();
		$(".user_info_errors").empty();
		$(".log_in_div").show();
		$(".sign_up_div").hide();
	});

  
  $("#clone_shipping_address").on("click", function(){
    if ($(this).is(':checked')) {
      var shipping_first_name = $("input[name='payment_info[shipping_address_first_name]']").val();
      var shipping_last_name = $("input[name='payment_info[shipping_address_last_name]']").val();
      var shipping_street_address = $("input[name='payment_info[shipping_address_street_address]']").val();
      var shipping_street_address2 = $("input[name='payment_info[shipping_address_street_address2]']").val();
      var shipping_city = $("input[name='payment_info[shipping_address_city]']").val();
      var shipping_state_id = $("select[name='payment_info[shipping_address_state_id]']").val();
      var shipping_zip_code = $("input[name='payment_info[shipping_address_zip_code]']").val();
      var shipping_phone_number = $("input[name='payment_info[shipping_address_phone_number]']").val();
      
      
      $("input[name='payment_info[billing_address_first_name]']").val(shipping_first_name);
      $("input[name='payment_info[billing_address_last_name]']").val(shipping_last_name);
      $("input[name='payment_info[billing_address_street_address]']").val(shipping_street_address);
      $("input[name='payment_info[billing_address_street_address2]']").val(shipping_street_address2);
      $("input[name='payment_info[billing_address_city]']").val(shipping_city);
      $("select[name='payment_info[billing_address_state_id]']").val(shipping_state_id);
      $("input[name='payment_info[billing_address_zip_code]']").val(shipping_zip_code);
      $("input[name='payment_info[billing_address_phone_number]']").val(shipping_phone_number);

    }
  });

});