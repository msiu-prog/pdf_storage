function check_teacher_name(form) {
  if(form.teacher_name.value == "") {
    alert("Введите имя преподавателя");
    form.teacher_name.focus();
    return false;
  }

  return true ;
}
