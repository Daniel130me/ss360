<?php
session_start();
include_once("model/connect.php");
$school_id = $_SESSION['school_id'];
$select = mysqli_query($conn, "SELECT s.session_id as session,s.term_id as term_id, s.maplocation as maplocation, s.radius as radius, t.* FROM skul_settings t, school s WHERE t.school_id='$school_id' AND s.id=t.school_id AND t.session_id=s.session_id AND s.term_id=t.term_id");

$row = mysqli_fetch_array($select);
?>

<input type="hidden" name="action" value="settings">
<div class="info-container mt-4 mb-4">
    <div class="form-group mb-4">
        <p class="p-0 mb-0 muted-text">Select Session</p>
        <select name="session_id" id="singleSessionValue" class="form-control select2" id="" style="max-width: 120px;">
            <?php
            $select_session = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");

            while ($row_session = mysqli_fetch_array($select_session)) {
                if ($row['session'] === $row_session['id']) {
            ?>
                    <option selected value="<?= $row_session['id'] ?>"><?= $row_session['session'] ?></option>
                <?php
                } else {
                ?>
                    <option value="<?= $row_session['id'] ?>"><?= $row_session['session'] ?></option>
            <?php }
            } ?>
        </select>
    </div>

    <div class="info-container mb-4">
        <p class="font-weight-bold">Assessment setting</p>
        <div class="d-flex flex-wrap mt-2">
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="ca1" id="ca1" <?= $row['ca1'] == '1' ? 'checked' : '' ?> />
                <label for="ca1">CA1
                </label>
            </div>
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="ca2" id="ca2" <?= $row['ca2'] == '1' ? 'checked' : '' ?> />
                <label for="ca2">CA2
                </label>
            </div>
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="ca3" id="ca3" <?= $row['ca3'] == '1' ? 'checked' : '' ?> />
                <label for="ca3">CA3
                </label>
            </div>
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="practical" id="practical" <?= $row['practical'] == '1' ? 'checked' : '' ?> />
                <label for="practical">Practical
                </label>
            </div>
            <div class="icheck-primary">
                <input type="checkbox" name="exam" id="exam" <?= $row['exam'] == '1' ? 'checked' : '' ?> />
                <label for="exam">Exam
                </label>
            </div>
        </div>
    </div>
    <p class="font-weight-bold">Term setting</p>
    <div id="">
        <p class="p-0 mb-0 muted-text">Select Current Term</p>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '1' ? 'active' : ''?> my-1 mr-2" data-name="1" onclick="toggle_term_setting(this)">1st Term</a>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '2' ? 'active' : ''?> my-1 mr-2" data-name="2" onclick="toggle_term_setting(this)">2nd Term</a>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '3' ? 'active' : ''?> my-1 mr-2" data-name="3" onclick="toggle_term_setting(this)">3rd Term</a>
    </div>
    <div class="row mb-2">
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">2nd Term commences</p>
            <input type="date" name="second_term_date" value="<?= $row['second'] ?>" class="form-control">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">3rd Term commences</p>
            <input type="date" name="third_term_date" value="<?= $row['third'] ?>" class="form-control">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">1st Term commences[new session]</p>
            <input type="date" name="first_term_date" value="<?= $row['first'] ?>" class="form-control">
        </div>
    </div>
    <div class="row mb-3">
        <div class="form-group col-12 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 font-weight-bold">No of Times School Opened</p>
            <input type="number" placeholder="90" title="number of times school opens" name="school_open" value="<?=$row['school_open']?>" id="school_open" class="form-control">
        </div>
    </div>

    

    <p class="font-weight-bold">Grade setting</p>
    <?php
    $skul_setting = json_decode($_SESSION['skul_settings'],true);
    $grade = json_decode($skul_setting['grading'],true);
    foreach($grade as $key => $value) {
    ?>
    <div class="d-flex align-items-center">
        <div class="form-group mr-2">
            <p class="p-0 mb-0 muted-text small">Grade</p>
            <input style="max-width: 100px;" type="text" name="" value="<?=$key?>" class="form-control grade_letter">
        </div>
        <div class="form-group">
            <p class="p-0 mb-0 muted-text small">Start from</p>
            <input style="max-width: 100px;" type="number" name="" value="<?=$value?>" class="form-control grade_value">
        </div>
    </div>
    <?php } ?>
    <p class="font-weight-bold">Location settings</p>
    <p class="small">This settings will be used for staff attendance</p>
<button type="button" class="btn btn-primary mb-3" id="set_location">Set School Location</button>
    <div id="map_container" style="display: none;">
        <div class="form-group">
            <label for="radius_input">Radius (in meters)</label>
            <input type="number" class="form-control" id="radius_input" value="100" style="width: 150px; margin-bottom: 10px;">
        </div>
        <div id="location_map" style="height: 400px;"></div>
    </div>
    <?php
        $maplocation = isset($row['maplocation']) && !empty($row['maplocation']) ? explode(',', $row['maplocation']) : [null, null];
        $latitude = $maplocation[0];
        $longitude = $maplocation[1];
        $radius = isset($row['radius']) ? $row['radius'] : 100;
    ?>
    <input type="hidden" id="latitude" name="latitude" value="<?php echo $latitude; ?>">
    <input type="hidden" id="longitude" name="longitude" value="<?php echo $longitude; ?>">
    <input type="hidden" id="radius" name="radius" value="<?php echo $radius; ?>">

</div>
<div class="row">
    <div class="col-12 col-md-auto mb-2 mb-md-0">
        <button type="submit" class="btn btn-primary btn-block btn-md-auto">Save Settings</button>
    </div>
</div>
<script>
    const gvalue = document.querySelectorAll(".grade_value")[document.querySelectorAll(".grade_value").length-1].disabled = true;

    function initializeMapSetup() {
        var setLocationButton = document.getElementById('set_location');
        if (!setLocationButton) {
            console.error("'Set Location' button not found.");
            return;
        }

        var mapInitialized = false;
        var map, marker, circle;

        setLocationButton.addEventListener('click', function() {
            var mapContainer = document.getElementById('map_container');
            
            if (mapContainer.style.display === 'none') {
                mapContainer.style.display = 'block';
                this.textContent = 'Hide Map';
                if (!mapInitialized) {
                    initializeMapLogic();
                    mapInitialized = true;
                }
            } else {
                mapContainer.style.display = 'none';
                this.textContent = 'Set School Location';
            }
        });

        function initializeMapLogic() {
            var latInput = document.getElementById('latitude');
            var lonInput = document.getElementById('longitude');
            var radiusInput = document.getElementById('radius');
            var radiusDisplayInput = document.getElementById('radius_input');

            var latitude = parseFloat(latInput.value);
            var longitude = parseFloat(lonInput.value);
            var radius = parseFloat(radiusInput.value) || 100;

            function initializeMap(lat, lon, rad) {
                if (map) {
                    map.remove();
                }
                map = L.map('location_map').setView([lat, lon], 16);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                }).addTo(map);

                marker = L.marker([lat, lon], { draggable: true }).addTo(map);
                circle = L.circle([lat, lon], { radius: rad }).addTo(map);

                latInput.value = lat;
                lonInput.value = lon;
                radiusInput.value = rad;
                radiusDisplayInput.value = rad;

                L.Control.geocoder({
                    defaultMarkGeocode: false
                })
                .on('markgeocode', function(e) {
                    var latlng = e.geocode.center;
                    map.setView(latlng, 16);
                    marker.setLatLng(latlng);
                    circle.setLatLng(latlng);
                    latInput.value = latlng.lat;
                    lonInput.value = latlng.lng;
                })
                .addTo(map);

                var lc = L.control.locate({
                    position: 'topright',
                    strings: {
                        title: "Go to my location"
                    },
                    flyTo: true
                }).addTo(map);

                map.on('locationfound', function(e) {
                    var latlng = e.latlng;
                    marker.setLatLng(latlng);
                    circle.setLatLng(latlng);
                    latInput.value = latlng.lat;
                    lonInput.value = latlng.lng;
                });

                marker.on('dragend', function(event) {
                    var position = marker.getLatLng();
                    latInput.value = position.lat;
                    lonInput.value = position.lng;
                    circle.setLatLng(position);
                });
            }

            if (!isNaN(latitude) && !isNaN(longitude) && latitude != 0 && longitude != 0) {
                initializeMap(latitude, longitude, radius);
            } else {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var currentLat = position.coords.latitude;
                    var currentLon = position.coords.longitude;
                    initializeMap(currentLat, currentLon, 100);
                }, function(error) {
                    console.log("Entering geolocation error callback.");
                    console.error("Geolocation error object:", error);
                    var fallbackLat = 51.505;
                    var fallbackLon = -0.09;
                    var alertMessage = "Could not get your current location. Using a default location.\n\nReason: " + error.message;
                    if (window.location.protocol !== 'https:') {
                        alertMessage += "\n\nNote: Geolocation may require a secure connection (HTTPS).";
                    }
                    alert(alertMessage);
                    initializeMap(fallbackLat, fallbackLon, 100);
                });
            }

            radiusDisplayInput.addEventListener('input', function() {
                var newRadius = parseFloat(this.value);
                if (!isNaN(newRadius) && newRadius > 0) {
                    radiusInput.value = newRadius;
                    if (circle) {
                        circle.setRadius(newRadius);
                    }
                }
            });
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeMapSetup);
    } else {
        initializeMapSetup();
    }
</script>