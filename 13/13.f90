program thirteen
  implicit none
  integer :: timestamp
  character(1000) :: buses_line
  integer :: buses_line_position = 1
  integer :: position_diff = 0
  integer :: first_bus_id = 0
  integer :: bus_eta = 0
  integer :: temp_bus_id
  integer :: temp_bus_eta
  integer :: bus_count = 1
  integer, dimension(100) :: schedule
  integer :: i
  integer :: j
  integer :: match_progress
  integer :: delta

  do i = 1, 100
     schedule(i) = 0
  end do

  open(10, file = "input.txt", action="read")
  read(10, *) timestamp
  read(10, '(A)') buses_line
  close(10)
  read(buses_line, *) first_bus_id
  schedule(1) = first_bus_id
  i = 2
  bus_eta = ((timestamp / first_bus_id + 1) * first_bus_id) - timestamp
  do
     position_diff = index(buses_line(buses_line_position + 1:), ",")
     buses_line_position = buses_line_position + position_diff
     if (position_diff == 0) then
        exit
     else if (buses_line(buses_line_position+1:buses_line_position+1) /= "x") then
        read(buses_line(buses_line_position+1:), *) temp_bus_id
        schedule(i) = temp_bus_id
        temp_bus_eta = ((1 + (timestamp / temp_bus_id)) * temp_bus_id) - timestamp
        if (temp_bus_eta < bus_eta) then
           first_bus_id = temp_bus_id
           bus_eta = temp_bus_eta
        end if
     else
        schedule(i) = 0
     end if
     i = i + 1
  end do
  write (*,*) "Part 1: ", first_bus_id * bus_eta

  bus_count = i
  delta = 1
  i = delta
  match_progress = 1
  do
     j = match_progress
     if (schedule(j) == 0) then
        match_progress = match_progress + 1
        cycle
     end if
     if (mod(i + j - 1, schedule(j)) == 0) then
        delta = delta * schedule(j)
        match_progress = match_progress + 1
     end if
     if (match_progress == bus_count) then
        write (*,*) "Part 2: ", i
        exit
     end if
     i = i + delta
  end do
end program thirteen
