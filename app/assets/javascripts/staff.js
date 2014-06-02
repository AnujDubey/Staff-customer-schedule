/* Javascript for Staff profile */
$(document).ready(function() {

    
    //designing the signup page back-end box when the error ocurres 
    if(jQuery("#new_user div>div").hasClass('field_with_errors')){
        jQuery("#signuppage").css({'height':'900px'});
    }
    if(jQuery(".new-staff-inner div>div").hasClass('field_with_errors')){
        jQuery(".new-staff-inner #new_user").css({'height':'390px'});
    }
});

function get_calender()
{
    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    var one_event = [];

    /* Fetching event from server side and storing it in an array */
    $.ajax({
        url: '/users/staff_post_task',
        method: 'post',
        dataType: 'JSON',
        async: false,
        success: function (data) {
            for (var i = 0; i < data.length; i++) {
                one_event[i] = {};
                one_event[i]["title"] = data[i]["title"];
                one_event[i]["start"] = new Date(data[i]["start_year"],data[i]["start_month"], data[i]["start_day"], data[i]["start_hour"], data[i]["start_minute"]);
                one_event[i]["end"] =  new Date(data[i]["end_year"],data[i]["end_month"], data[i]["end_day"], data[i]["end_hour"], data[i]["end_minute"]);
                one_event[i]["allDay"] = false;
                one_event[i]["task_id"] = data[i]["id"]
            }
        },
        failure: function (msg) {
            console.log("Error in Post");
        }
    });

    /* Using the FullCalender plugin to show it in staffs profile to schedule the staffs day or month */
    var calendar = $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        selectable: true,
        selectHelper: true,
        weekends: false,
        allDaySlot: 'false',
        disableDragging: true,
        minTime: '8am',
        maxtime: '6pm',
        select: function (start, end, allDay ) {
            var view = $('#calendar').fullCalendar('getView');
            console.log(view.name);
            if(view.name == "month") {
                $("#myModal input[type='text']").val("");
                $("#start_year").val(start);
                $("#end_year").val(end);
                $("#event_error").css("display", "none");
                $("#myModal").modal('show');
            }
            else
            {
                console.log("going inelse");
                var title = prompt('Event Title:');
                $.ajax({
                    url: '/users/save_task',
                    method: 'post',
                    data: {
                        "title": title,
                        "end_date": end,
                        "start_date": start,
                        "name": "agendaWeek"
                    },
                    success: function (msg) {
                        console.log(msg);
                    },
                    failure: function (msg) {
                        console.log("Error in sending the data");
                    }
                });
            }
            if (title) {
                calendar.fullCalendar('renderEvent', {
                        title: title,
                        start: start,
                        end: end,
                        allDay: allDay
                    },
                    true // make the event "stick"
                );
            }

            calendar.fullCalendar('unselect');
        },
        editable: true,
        events: one_event,
        timeFormat: 'h(:mm)',

        /* After click on an event set its color to red. */
        eventClick: function (calEvent, jsEvent, view) {
            bootbox.confirm("Are you sure? Delete " + calEvent.title + "? ", function(result) {
                location.reload();
                console.log(calEvent.task_id);
                if ( result == true ){
                     $.ajax({
                        url: '/users/delete_event',
                        method: 'post',
                        dataType: 'JSON',
                        async: false,
                        data:{
                                "task_id": calEvent.task_id
                        },
                        /* On Success deleting the Task assigned */
                        success: function(data) {
                            console.log("Slot alloted");
                            staffScheduleDiv();
                        },
                        failure: function(error){
                        }
                    });
                }
                else {}
                $(this).css('border-color', 'red');
           });
       }
    });
}
// /* To show the Customer in the admin profile */
// function customerDivshow() {
//     jQuery('#all_staffs').fadeOut('medium');
//       jQuery('#all_customers').fadeIn('medium');
// }

function staffMeetingDiv(){
    // location.reload();
    jQuery('#calendar').hide();
    jQuery('.staff-info').hide();
    jQuery('.left-meeting-div').show();
}
function staffScheduleDiv(){
     // location.reload();
    jQuery('.left-meeting-div').hide();
    jQuery('.staff-info').hide();
    $('#calendar').fullCalendar('destroy');
    jQuery('#calendar').show();
    get_calender();
}
function staffProfileDiv(){
    // location.reload();
    $('#calendar').fullCalendar('destroy');
    jQuery('#calender').hide();
    jQuery('.left-meeting-div').hide();
    jQuery('.staff-info').show();
}