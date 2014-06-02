/* JavaScript for User Profile */
$(document).ready(function(){
    var one_event = [];
    $('#post_customer_id').change(function() {
        one_event = [];
        task_assigned = [];
        var staff_id = $(this).val();

        /* Fetching event from server side and storing it in an array */
        $.ajax({
            url: '/users/staff_post_task',
            method: 'post',
            dataType: 'JSON',
            async: false,
            data: {
                "user_id": staff_id
            },
            success: function(data) {
                console.log(data.length);
                console.log(data);
                for(var i = 0; i < data.length; i++){
                    one_event[i] = {};
                    one_event[i]["title"] = data[i]["title"];
                    one_event[i]["start"] = new Date(data[i]["start_year"],data[i]["start_month"], data[i]["start_day"], data[i]["start_hour"], data[i]["start_minute"]);
                    one_event[i]["end"] =  new Date(data[i]["end_year"],data[i]["end_month"], data[i]["end_day"], data[i]["end_hour"], data[i]["end_minute"]);
                    one_event[i]["allDay"] = false;
                    one_event[i]["task_id"] = data[i]["id"]
                }
            },
            failure: function(msg){
                console.log("Error in sending the data");
            }
        });
        console.log(one_event);
        $('#calendar_customer').fullCalendar('destroy');

        /* Using the FullCalender plugin to show it in Customer profile to schedule 
        the staffs day or month and to fix the appointment  */
        var calendar = $('#calendar_customer').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
            selectable: false,
            selectHelper: false,
            weekends: false,
            allDaySlot: 'false',
            minTime: '8am',
            maxtime: '6pm',
            select: function(start, end, allDay, view) {
                var title = prompt('Event Title:');
                if (title) {
                    calendar.fullCalendar('renderEvent',{
                            title: title,
                            start: start,
                            end: end,
                            allDay: allDay,
                        },
                        true // make the event "stick"
                    );
                }
                calendar.fullCalendar('unselect');
            },
            editable: false,
            events: one_event,

            /* After click on an event the slot will be booked 
            Passing the data in from of json. */
            eventClick: function(calEvent, jsEvent, view) {
                var event_name = calEvent.title;
                var event_start = calEvent.start;
                var event_end = calEvent.end;
                var task_id =  calEvent.task_id;
                console.log(this);
                bootbox.confirm("Are you sure? Book this slot? ", function(result) {
                        if ( result == true )
                        {
                            $.ajax({
                                url: '/users/fix_meeting',
                                method: 'post',
                                dataType: 'JSON',
                                async: false,
                                data:{
                                        "task_id": calEvent.task_id
                                },
                                /* On Success Saving the Task assigned */
                                success: function(data) {
                                    console.log(data);
                                    if(data.user_id == 125555)
                                    {
                                        alert("Sorry!! This slot is already booked ");
                                    }

                                    else
                                    {
                                        for(var i = 0; i < data.length; i++){
                                            task_assigned[i] = {};
                                            task_assigned[i]["user_id"] = data[i]["user_id"];
                                            task_assigned[i]["title"] = data[i]["title"];
                                            task_assigned[i]["start"] = data[i]["start"];
                                            task_assigned[i]["end"] = data[i]["end"];
                                            task_assigned[i]["customer_id"] = data[i]["customer_id"];
                                            task_assigned[i]["staff_name"] = data[i]["staff_name"];
                                        }   
                                        //location.reload();
                                        alert("Slot alloted to you");
                                        console.log(this);
                                        $(this).removeClass("fc-event-inner").addClass("bg-colrs");
                                    }
                                },
                                failure: function(error){
                                    alert("Sorry!! This slot is already booked");
                                }
                            });

                        }
                        else
                        {

                        }
                });    
            }
        });
    });
});
function customerAppointmentDiv(){
    jQuery('.customer-info').hide();
    jQuery('#calendar_customer').hide();
    jQuery('.staff-dropdown').hide();
    jQuery('.customer-appointment-div').show();
}
function customerProfileDiv(){
    jQuery('.customer-appointment-div').hide();
    jQuery('#calendar_customer').hide();
    jQuery('.staff-dropdown').hide();
    jQuery('.customer-info').show();
}
function customerScheduleDiv(){
    jQuery('.customer-appointment-div').hide();
    jQuery('.customer-info').hide();
    jQuery('#calendar_customer').show();
    jQuery('.staff-dropdown').show();
}
