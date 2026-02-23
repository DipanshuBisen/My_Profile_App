function scrollToSection(id) {
    document.getElementById(id).scrollIntoView({
        behavior: "smooth"
    });
}

function submitForm(event) {
    event.preventDefault();
    document.getElementById("form-message").innerText =
        "Thank you! Your message has been submitted.";
    return false;
}