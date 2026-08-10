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