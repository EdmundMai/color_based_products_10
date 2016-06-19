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
//= require jquery_nested_form
//= require jquery-ui
//= require turbolinks

$(document).on('keydown', '#new_shape_text_field', function(e) { 
  if (e.keyCode == 13) {
    var shape_name = $('#new_shape_text_field').val();
    $("#new_shape_text_field").remove();
    e.preventDefault();
    jQuery.ajax({
      url: "/admin/shapes",
      type: 'POST',
      data: {"shape": {"name": shape_name} },
      dataType: 'script'
    });
  }
});


$(document).on('click', '#new_shape_option', function(e) { 
  if (!document.querySelector("#new_shape_text_field")) {
    $(".shape_container").append("<input id='new_shape_text_field' name='shape[name]' type='text' placeholder='Enter a shape name'></input>");
  }
});

$(document).on('keydown', '#new_material_text_field', function(e) { 
  if (e.keyCode == 13) {
    var material_name = $('#new_material_text_field').val();
    $("#new_material_text_field").remove();
    e.preventDefault();
    jQuery.ajax({
      url: "/admin/materials",
      type: 'POST',
      data: {"material": {"name": material_name} },
      dataType: 'script'
    });
  }
});


$(document).on('click', '#new_material_option', function(e) { 
  if (!document.querySelector("#new_material_text_field")) {
    $(".material_container").append("<input id='new_material_text_field' name='material[name]' type='text' placeholder='Enter a material name'></input>");
  }
});

$(document).on('keydown', '#new_color_text_field', function(e) { 
  var colors_select = $(this).siblings(".colors");
  var index_of_select_dropdown = $(".colors").index(colors_select);

  if (e.keyCode == 13) {
    var color_name = $('#new_color_text_field').val();
    $("#new_color_text_field").remove();
    e.preventDefault();
    jQuery.ajax({
      url: "/admin/colors",
      type: 'POST',
      data: {"color": {"name": color_name}, "index": index_of_select_dropdown},
      dataType: 'script'
    });
  }
});


$(document).on('click', '#new_color_option', function(e) { 
  $(this).parent().after("<input id='new_color_text_field' name='color[name]' type='text' placeholder='Enter a color name'></input>");
});


$(document).on('keydown', '#new_vendor_text_field', function(e) { 
  if (e.keyCode == 13) {
    var vendor_name = $('#new_vendor_text_field').val();
    $("#new_vendor_text_field").remove();
    e.preventDefault();
    jQuery.ajax({
      url: "/admin/vendors",
      type: 'POST',
      data: {"vendor": {"name": vendor_name} },
      dataType: 'script'
    });
  }
});


$(document).on('click', '#new_vendor_option', function(e) { 
  if (!document.querySelector("#new_vendor_text_field")) {
    $(".vendor_container").append("<input id='new_vendor_text_field' name='vendor[name]' type='text' placeholder='Enter a vendor name'></input>");
  }
});


function add_products_to_collection(collection_id) {
  var product_ids = new Array();
  $("#unassociated_product_ids").children('option:selected').each(function(){
    var value = $(this).val();
    product_ids.push(value);
  });
  jQuery.ajax({
    url: '/admin/collections/' + collection_id + '/add_products',
    type: 'POST',
    data: {"product_ids": product_ids},
    dataType: 'script'
  });
  return false;
}

function remove_products_from_collection(collection_id) {
  var product_ids = new Array();
  $("#associated_product_ids").children('option:selected').each(function(){
    var value = $(this).val();
    product_ids.push(value);
  });
  jQuery.ajax({
    url: '/admin/collections/' + collection_id + '/remove_products',
    type: 'DELETE',
    data: {"product_ids": product_ids},
    dataType: 'script'
  });
  return false;
}


function reset_product_search_for_collection(collection_id) {
  jQuery.ajax({
    url: '/admin/collections/' + collection_id + '/reset_search',
    type: 'GET',
    dataType: 'script'
  });
  return false;
}



$(function() {

  $("#remove_collection_from_discounts_list").on("click", function(){
    $("#chosen_collections_for_discounts_ids").children('option:selected').each(function(){
      $("#available_collections_for_discounts_ids").append($(this));
    });

    var not_discount_options = $("#available_collections_for_discounts_ids option");

    not_discount_options.sort(function(a,b){
      if (a.text.toLowerCase() > b.text.toLowerCase()) return 1;
      else if (a.text.toLowerCase() < b.text.toLowerCase()) return -1;
      else return 0
    });

    $("#available_collections_for_discounts_ids").html(not_discount_options);
    return false;

  });

  $("#add_collection_to_discounts_list").on("click", function(){
    $("#available_collections_for_discounts_ids").children('option:selected').each(function(){
      $("#chosen_collections_for_discounts_ids").append($(this));
    });

    var discount_options = $("#chosen_collections_for_discounts_ids option");

    discount_options.sort(function(a,b){
      if (a.text.toLowerCase() > b.text.toLowerCase()) return 1;
      else if (a.text.toLowerCase() < b.text.toLowerCase()) return -1;
      else return 0
    });

    $("#chosen_collections_for_discounts_ids").html(discount_options);
    return false;
  });

  $("#remove_product_from_discounts_list").on("click", function(){
    $("#chosen_products_for_discounts_ids").children('option:selected').each(function(){
      $("#available_products_for_discounts_ids").append($(this));
    });

    var not_discount_options = $("#available_products_for_discounts_ids option");

    not_discount_options.sort(function(a,b){
      if (a.text.toLowerCase() > b.text.toLowerCase()) return 1;
      else if (a.text.toLowerCase() < b.text.toLowerCase()) return -1;
      else return 0
    });

    $("#available_products_for_discounts_ids").html(not_discount_options);
    return false;

  });

  $("#add_product_to_discounts_list").on("click", function(){
    $("#available_products_for_discounts_ids").children('option:selected').each(function(){
      $("#chosen_products_for_discounts_ids").append($(this));
    });

    var discount_options = $("#chosen_products_for_discounts_ids option");

    discount_options.sort(function(a,b){
      if (a.text.toLowerCase() > b.text.toLowerCase()) return 1;
      else if (a.text.toLowerCase() < b.text.toLowerCase()) return -1;
      else return 0
    });

    $("#chosen_products_for_discounts_ids").html(discount_options);
    return false;
  });

  $("#product_name_search").on('keydown', function(e){
    if (e.keyCode == 13) {
      e.preventDefault();
      var collection_id = $("#collection_id").val();
      var search_term = $("#product_name_search").val();
      jQuery.ajax({
        url: '/admin/collections/' + collection_id + '/search_products',
        type: 'GET',
        data: {"id": collection_id, "search_term": search_term},
        dataType: 'script'
      });
    }
  });



  if($("#coupon_type option:selected").text() == "Free Shipping") {
    $(".coupon_value_div").hide();
  }

  $("#coupon_type option").on("click", function(){
    var coupon_type = $(this).val();
    if (coupon_type == 'FreeShippingCoupon') {
      $(".coupon_value_div").hide();
    } else if (coupon_type == 'PercentageCoupon') {
      $('#coupon_value option').text(function(i, s){ return s.replace(/^\$(.+)$/, '$1%'); });
      $(".coupon_value_div").show();
    } else if (coupon_type == 'FlatCoupon') {
      $('#coupon_value option').text(function(i, s){ return s.replace(/^(.+)%$/, '$$$1'); });
      $(".coupon_value_div").show();
    }
  });


  $(".datepicker").datepicker();

  $("#master_price").on("change keyup", function() {
    $(".variant_price").val($(this).val());
  });

  $('.sorted_product_mens_color_list').sortable({
    update: function( event, ui ) {
      var id_list = new Array();
      $(".sorted_product_mens_color_list li").each(function(index){
        id_list[index] = $(this).attr("id");
      });
      jQuery.ajax({
        url: '/admin/products_colors/update_mens_sort_order',
        type: 'PUT',
        data: {"new_order": id_list},
        dataType: 'script'
      });
    }
  });

  $('.sorted_product_womens_color_list').sortable({
    update: function( event, ui ) {
      var id_list = new Array();
      $(".sorted_product_womens_color_list li").each(function(index){
        id_list[index] = $(this).attr("id");
      });
      jQuery.ajax({
        url: '/admin/products_colors/update_womens_sort_order',
        type: 'PUT',
        data: {"new_order": id_list},
        dataType: 'script'
      });
    }
  });


  $('.sorted_product_image_list').sortable({
    update: function( event, ui ) {
      var id_list = new Array();
      $(".sorted_product_image_list li").each(function(index){
        id_list[index] = $(this).attr("id");
      });
      jQuery.ajax({
        url: '/admin/product_images/update_sort_order',
        type: 'PUT',
        data: {"new_order": id_list},
        dataType: 'script'
      });
    }
  });


  $("#generate_variants_link").on("click", function(){

    var price = $("#price").val();

    var selected_sizes_and_measurements = {};
    $(".size_inputs").each(function(i, div){
      var size = $(div).find(".sizes").val();
      var measurements = $(div).find(".measurements").val();
      if (size) {
        selected_sizes_and_measurements[size] = measurements;
      }
    });

    var selected_sizes_and_weights = {};
    $(".size_inputs").each(function(i, div){
      var size = $(div).find(".sizes").val();
      var weight = $(div).find(".weight").val();
      if (size) {
        selected_sizes_and_weights[size] = weight;
      }
    });

    var selected_colors_and_genders = {};
    $(".color_inputs").each(function(i, div){
      var color = $(div).find(".colors").val();
      var genders = $(div).find("input:checkbox[name='gender[]']:checked").map(function(){return $(this).val();}).get();
      genders.push("none");
      if (color) {
        selected_colors_and_genders[color] = genders;
      }
    });


    jQuery.ajax({
      url: "/admin/products/generate_variants",
      type: 'GET',
      data: {"price": price, 
        "sizes_and_measurements": selected_sizes_and_measurements, 
        "colors_and_genders": selected_colors_and_genders,
        "sizes_and_weights": selected_sizes_and_weights
      },
      dataType: 'script'
    });

    return false;
  });

});
