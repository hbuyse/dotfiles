function copy_text(clicked_id) {
  // Get the text field
  var img = document.getElementById(clicked_id);

   // Copy the text inside the text field
  navigator.clipboard.writeText(img.src);

  // Alert the copied text
  console.log("Copied the text: " + img.src);
}
