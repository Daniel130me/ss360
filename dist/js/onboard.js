function ismatched() {
    if ($("#password").val() !== $("#password1").val()) {
        toastr.error('Password does not match!')
        $("#staff_reg_submit").attr("disabled", true)
    } else {
        $("#staff_reg_submit").attr("disabled", false)
    }
}

function preview_image(event) {
    var reader = new FileReader();
    reader.onload = function () {
        var img = event.target.previousElementSibling;
        event.target.nextElementSibling.nextElementSibling.innerHTML =
            event.target.value.split("\\").pop();
        img.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
}

$("#add_more_btn").click(function () {
    $(`<div class="form-group d-flex align-item-center flex-row mb-3 field">
        <input type="text" class="form-control" value="English"  onkeyup="update_name(this)" placeholder="Subject">
        <button type="button" class="ml-2 bg-primary btn text-danger" onclick="remove_field(this)">x</button>
    </div>`).appendTo("#subject_field")
    // $(".field:last").clone(true).appendTo("#subject_field")
    $(".field:last input").val("").focus()
})

const remove_field = (event) => $(event).parents('.field').remove()

$(".remove_field").click(function (event) {
    $(this).parents('.field').remove()
})

const update_name = (event) => $(event).attr('name', `${$(event).val()}`)
// alert('lk')
$(".onboard_form").submit(function (event) {
    event.preventDefault();
    var $form = $(this);
    let $btn = $form.find("#staff_reg_submit")
    let $btntext = $btn.html()
    // let $btntext = $btn.html()
    var $url = $form.attr("action");
    // alert($url)
    let formdata = new FormData(this);
    $.ajax({
        url: $url,
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: ()=> {
            $($btn).attr("disabled", true)
            $($btn).html("Processing")
        },
        success: (data) => {
            $($btn).attr("disabled", false)
            $($btn).html($btntext)
            data = JSON.parse(data)
            if (data.status == '1') {
                window.location = `./${data.location}`
            }
            else{
                toastr.error(data.err)
            }
        },
        error: (xhr, status, error) => {
            console.error('Error: ' + error);
        }
    });
});

// $.validator.setDefaults({
//     submitHandler: function () {
//         alert("Form successful submitted!");
//     }
// });
// $('#onboard_staff_form').validate({
//     rules: {
//         email: {
//             required: true,
//             email: true,
//         },
//         password: {
//             required: true,
//             minlength: 3
//         },
//         firstname: {
//             required: true
//         },
//         lastname: {
//             required: true
//         },
//         phone: {
//             required: true
//         }
//     },
//     messages: {
//         email: {
//             required: "Please enter a email address",
//             email: "Please enter a valid email address"
//         },
//         password: {
//             required: "Please provide a password",
//             minlength: "Your password must be at least 5 characters long"
//         },
//         firstname: {
//             required: "Please provide your first name"
//         }
//     },
//     errorElement: 'span',
//     errorPlacement: function (error, element) {
//         error.addClass('invalid-feedback');
//         element.closest('.form-group').append(error);
//     },
//     highlight: function (element, errorClass, validClass) {
//         $(element).addClass('is-invalid');
//     },
//     unhighlight: function (element, errorClass, validClass) {
//         $(element).removeClass('is-invalid');
//     }
// });

$('.select2').select2()