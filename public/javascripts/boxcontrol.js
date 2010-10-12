Event.observe(window, "load", function() {
  var toggle_network_static_inputs = function(enable) {
    $('network_static_inputs').select("input[type=text]").each(function(input) {
      if (enable) {
        input.enable();
      } else {
        input.disable();
      }
    });
  };

  $$('input[type=radio][name="network[method]"]').each(function(radio) {
    if (radio.value == "static") {
      toggle_network_static_inputs(radio.checked);
    }
    Event.observe(radio, 'change', function() {
      toggle_network_static_inputs(radio.getValue() == "static");
    });
  });
});
