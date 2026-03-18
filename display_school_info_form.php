<?php
session_start();
include_once("model/connect.php");
$school_id = $_SESSION['school_id'];
$select = mysqli_query($conn, "SELECT * FROM school WHERE id='$school_id'");
$row = mysqli_fetch_array($select);

// echo $row['back_pic'];
// exit;
?>
<input type="hidden" name="action" value="school_info_update">
<div class="mb-4 mt-4 info-container">
    <p class="font-weight-bold">School Information</p>
    <div class="row">
        <div class="form-group col-12 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">School Name</p>
            <input type="text" name="schoolname" value="<?= $row['school_name'] ?>" class="form-control" title="Enter school name">
        </div>
    </div>
    <div class="row">
        <div class="form-group col-12 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Description</p>
            <p class="p-0 mb-0 small">Write a few information about the school</p>
            <textarea name="description" class="form-control" cols="4" rows="3" title="Enter school description"><?= $row['description'] ?></textarea>
        </div>
        <div class="d-flex flex-wrap w-100" style="gap: 1rem;">
            <div class="form-group col-12 ml-0 mt-2" style="position:relative; max-width: 100px;">
                <img title="Click to select logo" src="../uploads/<?= $row['logo'] == '' ? 'logo-placeholder.png' : $row['logo'] ?>" alt="School Logo" width="100" height="100">
    
                <input type="file" name="logo" accept="image/png, image/jpeg, image/jpg"
                    id="image_profile_add_1"
                    style="display: none;"
                    onchange="preview_image(event)"
                    class="form-control"
                    title="Upload school logo">
    
                <label for="image_profile_add_1" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">
                    Select logo
                </label>
    
                <p class="small mb-0 text-center">Click to select logo</p>
            </div>
    
            <div class="form-group col-12 ml-0 mt-2" style="position:relative; max-width: 100px;">
                <img title="Click to select background picture" src="../uploads/<?= $row['back_pic'] == '' ? 'logo-placeholder.jpg' : $row['back_pic'] ?>" alt="Background Picture" width="100" height="100">
    
                <input type="file" name="back_gpic" accept="image/png, image/jpeg, image/jpg"
                    id="image_backg"
                    style="display: none;"
                    onchange="preview_image(event)"
                    class="form-control"
                    title="Upload background picture">
    
                <label for="image_backg" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">
                    Select Background picture
                </label>
    
                <p class="small mb-0 text-center">Click to select background picture</p>
            </div>
            <div class="form-group col-12 ml-0 mt-2" style="position:relative; max-width: 100px;">
                <img title="Click to select background picture" src="../uploads/<?= $row['stamp_pic'] == '' ? 'logo-placeholder.jpg' : $row['stamp_pic'] ?>" alt="Background Picture" width="100" height="100">
    
                <input type="file" name="stamp_pic" accept="image/png, image/jpeg, image/jpg"
                    id="image_stamp"
                    style="display: none;"
                    onchange="preview_image(event)"
                    class="form-control"
                    title="Upload School Stamp with signature">
    
                <label for="image_stamp" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">
                    Select school stamp
                </label>
    
                <p class="small mb-0 text-center">Click to select school stamp with signature</p>
            </div>
        </div>
    </div>
</div>
<div class="mb-4 info-container">
    <p class="font-weight-bold">Contact Information</p>
    <div class="row">
        <div class="form-group col-12 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Full Address</p>
            <input type="text" name="street" value="<?= $row['address'] ?>" autocomplete="address-level1" title="Enter street address" class="form-control" placeholder="64 Niel street, Opp. Dan Arena...">
        </div>
    </div>
    <div class="row">
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">City</p>
            <input type="text" name="city" autocomplete="address-level1" value="<?= $row['city'] ?>" class="form-control" placeholder="e.g Ikorodu" title="Enter city name">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">State</p>
            <input type="text" name="state" class="form-control" value="<?= $row['state'] ?>" placeholder="e.g Lagos" title="Enter state name">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Country</p>
            <input type="text" name="country" class="form-control" value="<?= $row['country'] ?>" placeholder="e.g Nigeria" title="Enter country name">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Phone number</p>
            <input type="text" name="phone1" class="form-control" value="<?= $row['phone1'] ?>" placeholder="e.g +234906667676" title="Enter primary phone number">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Alternative Phone number</p>
            <input type="text" name="phone2" class="form-control" value="<?= $row['phone2'] ?>" placeholder="e.g +234906667676" title="Enter alternative phone number">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">School Email Address</p>
            <input type="text" name="email" class="form-control" value="<?= $row['email'] ?>" placeholder="e.g demoschool@gmail.com" title="Enter school email address">
        </div>
    </div>
</div>
<div class="info-container mb-4">
    <p class="font-weight-bold">Socials</p>
    <div class="row">
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Twitter(X)</p>
            <input type="url" name="twitter" autocomplete="url" value="<?= $row['twitter'] ?>" title="Enter X (Twitter) profile URL" class="form-control" placeholder="e.g x.com/demoschool">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Facebook</p>
            <input type="url" name="facebook" autocomplete="url" value="<?= $row['facebook'] ?>" title="Enter Facebook profile URL" class="form-control" placeholder="e.g facebook.com/demoschool">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">Instagram</p>
            <input type="url" name="instagram" autocomplete="url" value="<?= $row['instagram'] ?>" title="Enter Instagram profile URL" class="form-control" placeholder="e.g instagram.com/demoschool">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">TikTok</p>
            <input type="url" name="tiktok" autocomplete="url" value="<?= $row['tiktok'] ?>" title="Enter TikTok profile URL" class="form-control" placeholder="e.g tiktok.com/demoschool">
        </div>
    </div>
</div>
<div class="row">
    <div class="col-12 col-md-auto mb-2 mb-md-0">
        <button type="submit" class="btn btn-primary btn-block btn-md-auto" title="Save school information updates">Save Update</button>
    </div>
</div>
<!-- </form> -->