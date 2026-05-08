<?php
session_start();
include_once("model/connect.php");
$school_id = $_SESSION['school_id'];
$select = mysqli_query($conn, "SELECT s.session_id as session,s.term_id as term_id, s.maplocation as maplocation, s.radius as radius, t.* FROM skul_settings t, school s WHERE t.school_id='$school_id' AND s.id=t.school_id AND t.session_id=s.session_id AND s.term_id=t.term_id");

$row = mysqli_fetch_array($select);
?>
<style>
    #reportCardsContainer {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
        margin-top: 20px;
        margin-bottom: 25px;
    }

    .premium-card {
        background: #ffffff;
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        padding: 20px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 160px;
        position: relative;
        overflow: hidden;
    }

    .premium-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        border-color: #cbd5e1;
    }

    .premium-card .card-status {
        position: absolute;
        top: 12px;
        right: 12px;
        font-size: 10px;
        text-transform: uppercase;
        padding: 2px 8px;
        border-radius: 12px;
        font-weight: 700;
        letter-spacing: 0.5px;
    }

    .status-on {
        background: #dcfce7;
        color: #166534;
    }

    .status-off {
        background: #fee2e2;
        color: #991b1b;
    }

    .premium-card .report-name {
        font-size: 1.05rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 12px;
        line-height: 1.4;
        padding-right: 40px;
    }

    .assessment-chips {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        margin-bottom: 15px;
    }

    .assessment-chip {
        background: #f1f5f9;
        color: #475569;
        padding: 3px 10px;
        border-radius: 8px;
        font-size: 0.75rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        border: 1px solid #e2e8f0;
    }

    .assessment-chip i {
        font-size: 0.65rem;
        margin-left: 6px;
        cursor: pointer;
        opacity: 0.5;
        transition: opacity 0.2s;
    }

    .assessment-chip i:hover {
        opacity: 1;
        color: #ef4444;
    }

    .card-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: auto;
        padding-top: 12px;
        border-top: 1px solid #f1f5f9;
    }

    .btn-premium-edit {
        color: #2563eb;
        background: #eff6ff;
        border: none;
        padding: 5px 12px;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.85rem;
        transition: all 0.2s;
    }

    .btn-premium-edit:hover {
        background: #2563eb;
        color: white;
    }

    .btn-premium-delete {
        color: #94a3b8;
        background: transparent;
        border: none;
        padding: 5px;
        border-radius: 6px;
        transition: all 0.2s;
    }

    .btn-premium-delete:hover {
        color: #ef4444;
        background: #fef2f2;
    }

    /* Modal Redesign */
    #assessmentModal .modal-content {
        border-radius: 20px;
        border: none;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    #assessmentModal .modal-header {
        border-bottom: 1px solid #f1f5f9;
        padding: 24px 28px;
    }

    #assessmentModal .modal-title {
        font-weight: 800;
        color: #0f172a;
        font-size: 1.25rem;
    }

    #assessmentModal .modal-body {
        padding: 28px;
    }

    .modal-section-label {
        font-weight: 700;
        color: #475569;
        font-size: 0.9rem;
        margin-bottom: 12px;
        display: block;
    }

    .assessment-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 12px;
        margin-bottom: 24px;
    }

    .modern-checkbox {
        position: relative;
        display: flex;
        align-items: center;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 12px 16px;
        cursor: pointer;
        transition: all 0.2s;
    }

    .modern-checkbox:hover {
        background: #f1f5f9;
        border-color: #cbd5e1;
    }

    .modern-checkbox.active {
        background: #eff6ff;
        border-color: #3b82f6;
    }

    .modern-checkbox input {
        width: 18px;
        height: 18px;
        margin-right: 12px;
        accent-color: #3b82f6;
    }

    .modern-checkbox span {
        font-weight: 600;
        color: #1e293b;
    }

    .status-panel {
        background: #f8fafc;
        border-radius: 12px;
        padding: 16px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border: 1px solid #e2e8f0;
    }

    .status-panel span {
        font-weight: 600;
        color: #475569;
    }

    #assessmentModal .modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 20px 28px;
    }

    .btn-rounded {
        border-radius: 12px;
        padding: 10px 24px;
        font-weight: 600;
        font-size: 0.95rem;
    }

    #addMoreReports {
        border-radius: 10px;
        padding: 8px 16px;
        font-weight: 600;
        border-width: 2px;
        transition: all 0.2s;
    }

    #addMoreReports:hover {
        background-color: #28a745;
        color: white;
        transform: translateY(-2px);
    }

</style>
<link rel="stylesheet" href="../dist/css/report_template_builder.css">

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
        <a class="btn select_btn term_setting <?= $row['term_id'] == '1' ? 'active' : '' ?> my-1 mr-2" data-name="1" onclick="toggle_term_setting(this)">1st Term</a>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '2' ? 'active' : '' ?> my-1 mr-2" data-name="2" onclick="toggle_term_setting(this)">2nd Term</a>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '3' ? 'active' : '' ?> my-1 mr-2" data-name="3" onclick="toggle_term_setting(this)">3rd Term</a>
    </div>
    <div id="reportCardsContainer">
        <!-- Reports will be loaded here via AJAX -->
    </div>
    <div class="row mb-3">
        <div class="col-12">
            <button type="button" id="addMoreReports" class="btn btn-sm btn-outline-success"><i class="fas fa-plus mr-1"></i> Add More Report</button>
        </div>
    </div>
    <div class="report-template-builder" id="reportTemplateBuilder">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
            <div>
                <p class="font-weight-bold mb-1">Report card format</p>
                <p class="p-0 mb-0 muted-text">Configure layout by term without changing score calculations.</p>
            </div>
            <div class="report-template-status small text-muted mt-2 mt-sm-0" id="reportTemplateStatusText"></div>
        </div>

        <div class="row">
            <div class="form-group col-12 col-md-4">
                <p class="p-0 mb-0 muted-text">Template Name</p>
                <input type="text" class="form-control" id="reportTemplateName" value="Default Report Card">
                <input type="hidden" id="reportTemplateId" value="">
            </div>
            <div class="form-group col-6 col-md-3">
                <p class="p-0 mb-0 muted-text">Applies To</p>
                <select class="form-control" id="reportTemplateTerm">
                    <option value="default">School Default</option>
                    <option value="1">1st Term</option>
                    <option value="2">2nd Term</option>
                    <option value="3">3rd Term</option>
                    <option value="cumulative">Cumulative</option>
                </select>
            </div>
            <div class="form-group col-6 col-md-3">
                <p class="p-0 mb-0 muted-text">Availability</p>
                <select class="form-control" id="reportTemplateStatus">
                    <option value="1">Active</option>
                    <option value="0">Inactive</option>
                </select>
            </div>
            <div class="form-group col-12 col-md-2 d-flex align-items-end">
                <div class="icheck-primary">
                    <input type="checkbox" id="reportTemplateDefault" value="1">
                    <label for="reportTemplateDefault">Default</label>
                </div>
            </div>
        </div>

        <div class="report-template-grid">
            <div class="report-template-panel">
                <div class="report-template-panel-title">Preset</div>
                <button type="button" class="report-template-preset" data-preset="basic_term">Basic Term</button>
                <button type="button" class="report-template-preset" data-preset="first_term">First Term</button>
                <button type="button" class="report-template-preset" data-preset="second_term_brought_forward">Second Term With B/F</button>
                <button type="button" class="report-template-preset" data-preset="third_term_cumulative">Third Term Cumulative</button>
                <button type="button" class="report-template-preset" data-preset="cumulative">Cumulative Summary</button>
            </div>

            <div class="report-template-panel">
                <div class="report-template-panel-title">Sections</div>
                <div class="report-toggle-grid" id="reportTemplateSections"></div>
            </div>

            <div class="report-template-panel">
                <div class="report-template-panel-title">Fields</div>
                <div class="report-toggle-grid" id="reportTemplateFields"></div>
            </div>
        </div>

        <div class="report-template-panel mt-3">
            <div class="report-template-panel-title">Score Table Columns</div>
            <div class="report-column-picker">
                <div>
                    <p class="p-0 mb-2 muted-text">Available Columns</p>
                    <div class="report-column-list" id="availableReportColumns"></div>
                </div>
                <div>
                    <p class="p-0 mb-2 muted-text">Selected Columns</p>
                    <div class="report-column-list" id="selectedReportColumns"></div>
                </div>
            </div>
            <div class="report-template-preview" id="reportTemplatePreview"></div>
        </div>

        <div class="d-flex flex-wrap justify-content-end mt-3">
            <button type="button" class="btn btn-light mr-2 mb-2" id="resetReportTemplateDraft">Reset Draft</button>
            <button type="button" class="btn btn-outline-primary mr-2 mb-2" id="loadReportTemplate">Load Format</button>
            <button type="button" class="btn btn-primary mb-2" id="saveReportTemplate">Save Format</button>
        </div>
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
            <input type="number" placeholder="90" title="number of times school opens" name="school_open" value="<?= $row['school_open'] ?>" id="school_open" class="form-control">
        </div>
    </div>



    <p class="font-weight-bold">Grade setting</p>
    <?php
    $skul_setting = json_decode($_SESSION['skul_settings'], true);
    $grade = json_decode($skul_setting['grading'], true);
    foreach ($grade as $key => $value) {
    ?>
        <div class="d-flex align-items-center">
            <div class="form-group mr-2">
                <p class="p-0 mb-0 muted-text small">Grade</p>
                <input style="max-width: 100px;" type="text" name="" value="<?= $key ?>" class="form-control grade_letter">
            </div>
            <div class="form-group">
                <p class="p-0 mb-0 muted-text small">Start from</p>
                <input style="max-width: 100px;" type="number" name="" value="<?= $value ?>" class="form-control grade_value">
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

<!-- Assessment Modal -->
<div class="modal fade" id="assessmentModal" tabindex="-1" role="dialog" aria-labelledby="assessmentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="assessmentModalLabel">Configure Report</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true" style="font-size: 1.5rem;">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group mb-4">
                    <label class="modal-section-label" for="modalReportName">Report Name</label>
                    <input type="text" class="form-control" id="modalReportName" placeholder="e.g. Mid-term Report"
                        style="border-radius: 12px; padding: 12px 16px; border: 1px solid #e2e8f0; font-weight: 500;">
                </div>

                <label class="modal-section-label">Select Assessments</label>
                <div class="assessment-grid">
                    <label class="modern-checkbox" for="checkCA1">
                        <input type="checkbox" id="checkCA1" class="assessment-checkbox" value="CA1">
                        <span>CA1</span>
                    </label>
                    <label class="modern-checkbox" for="checkCA2">
                        <input type="checkbox" id="checkCA2" class="assessment-checkbox" value="CA2">
                        <span>CA2</span>
                    </label>
                    <label class="modern-checkbox" for="checkCA3">
                        <input type="checkbox" id="checkCA3" class="assessment-checkbox" value="CA3">
                        <span>CA3</span>
                    </label>
                    <label class="modern-checkbox" for="checkPractical">
                        <input type="checkbox" id="checkPractical" class="assessment-checkbox" value="Practical">
                        <span>Practical</span>
                    </label>
                    <label class="modern-checkbox" for="checkExam">
                        <input type="checkbox" id="checkExam" class="assessment-checkbox" value="Exam">
                        <span>Exam</span>
                    </label>
                </div>

                <label class="modal-section-label">Availability</label>
                <div class="status-panel">
                    <span>Visible to Parents</span>
                    <div class="custom-control custom-switch">
                        <input type="checkbox" class="custom-control-input" id="reportStatusSwitch" checked>
                        <label class="custom-control-label" for="reportStatusSwitch"></label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light btn-rounded mr-2" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary btn-rounded" id="saveAssessmentChanges">Save Report</button>
            </div>
        </div>
    </div>
</div>
<script>
    const gvalue = document.querySelectorAll(".grade_value")[document.querySelectorAll(".grade_value").length - 1].disabled = true;

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

                marker = L.marker([lat, lon], {
                    draggable: true
                }).addTo(map);
                circle = L.circle([lat, lon], {
                    radius: rad
                }).addTo(map);

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
<script src="../dist/js/report_card_columns.js"></script>
<script src="../dist/js/report_template_builder.js"></script>
<script src="../dist/js/report_setting.js"></script>
