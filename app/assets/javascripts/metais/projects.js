document.addEventListener('DOMContentLoaded', function() {
    let sortDirectionField = document.getElementById('sort_direction');
    let sortButton = document.getElementById('ascdesctoggle');
    let upIcon = document.getElementById('up-icon');
    let downIcon = document.getElementById('down-icon');

    let toggleState = sortDirectionField.value || 'desc';

    if (toggleState === 'desc') {
        upIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
        downIcon.style.fill = 'rgb(56, 94, 255)';
    } else {
        upIcon.style.fill = 'rgb(56, 94, 255)';
        downIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
    }

    sortButton.addEventListener('click', function(event) {
        event.preventDefault();

        toggleState = (toggleState === 'asc') ? 'desc' : 'asc';
        sortDirectionField.value = toggleState;

        if (toggleState === 'desc') {
            upIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
            downIcon.style.fill = 'rgb(56, 94, 255)';
        } else {
            upIcon.style.fill = 'rgb(56, 94, 255)';
            downIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
        }

        document.getElementById('form').submit();
    });
});
    
$(document).ready(function() {
    function openFilterSection(sectionId) {
        var $filterSection = $('#' + sectionId);
        if ($filterSection.length) {
            $filterSection.toggleClass('show');
        }
    }

    var urlParams = new URLSearchParams(window.location.search);
    var status = urlParams.get('status');
    var guarantor = urlParams.get('guarantor');
    var code = urlParams.get('code');
    var minPrice = urlParams.get('min_price');
    var maxPrice = urlParams.get('max_price');
    var hasEvaluation = urlParams.get('has_evaluation');

    if (status || guarantor || code || minPrice || maxPrice || hasEvaluation) {
        openFilterSection('filterForm');
    }

    $('#filterButton').click(function() {
        openFilterSection('filterForm');
    });
});

$(document).ready(function() {
    function updateDropdownColors() {
        var urlParams = new URLSearchParams(window.location.search);

        var filters = [
            { param: 'status', buttonId: 'dropdownMenuButton' },
            { param: 'guarantor', buttonId: 'dropdownMenuButton2' },
            { param: 'code', buttonId: 'dropdownMenuButton3' },
            { param: 'min_price', buttonId: 'dropdownMenuButton4' },
            { param: 'has_evaluation', buttonId: 'dropdownMenuButton5' }
        ];

        filters.forEach(function(filter) {
            var filterValue = urlParams.get(filter.param);
            var $dropdownButton = $('#' + filter.buttonId);
            
            if (filterValue) {
                $dropdownButton.addClass('btn-active').removeClass('btn-outline-primary').addClass('btn-primary');
            } else {
                $dropdownButton.removeClass('btn-active').addClass('btn-outline-primary').removeClass('btn-primary');
            }
        });
    }

    updateDropdownColors();
});

function removeFilter(filter) {
  if (filter === 'price') {
    document.getElementById('min_price').value = '';
    document.getElementById('max_price').value = '';
  } else {
    document.getElementById(filter).value = '';
  }
    document.getElementById('form').submit();
  }