document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('add-student-form').addEventListener('submit', function(event) {
    event.preventDefault();
    const studentId = document.getElementById('student-id').value;
    if (studentId) {
      updateStudentRecord(studentId);
    } else {
      addStudent();
    }
  });
});

window.showAddStudentModal = function(student = {}) {
  document.getElementById('add-student-modal').style.display = 'block';
  
  // Pre-fill form fields if student data is provided
  document.getElementById('name').value = student.name || '';
  document.getElementById('subject_name').value = student.subject_name || '';
  document.getElementById('marks').value = student.marks || '';
  document.getElementById('student-id').value = student.id || '';  // Set student ID if editing
}

window.closeAddStudentModal = function() {
  document.getElementById('add-student-modal').style.display = 'none';
  // Clear form fields and student ID
  document.getElementById('name').value = '';
  document.getElementById('subject_name').value = '';
  document.getElementById('marks').value = '';
  document.getElementById('student-id').value = '';
}

window.addStudent = function() {
  const name = document.getElementById('name').value;
  const subject_name = document.getElementById('subject_name').value;
  const marks = document.getElementById('marks').value;

  fetch('/students', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('[name=csrf-token]').content
    },
    body: JSON.stringify({ student: { name, subject_name, marks } })
  })
  .then(response => response.json())
  .then(student => {
    const studentList = document.getElementById('student-list');
    const newRow = document.createElement('tr');
    newRow.setAttribute('data-id', student.id);
    newRow.innerHTML = `
      <td contenteditable="true" onblur="updateStudent(${student.id}, 'name', this.innerText)">${student.name}</td>
      <td contenteditable="true" onblur="updateStudent(${student.id}, 'subject_name', this.innerText)">${student.subject_name}</td>
      <td contenteditable="true" onblur="updateStudent(${student.id}, 'marks', this.innerText)" class="student-marks">${student.marks}</td>
      <td>
        <button onclick="deleteStudent(${student.id})">Delete</button>
        <button onclick="showEditStudentModal(${student.id})">Edit</button>
      </td>
    `;
    studentList.appendChild(newRow);
    closeAddStudentModal();
  });
}

window.updateStudentRecord = function(id) {
  const name = document.getElementById('name').value;
  const subject_name = document.getElementById('subject_name').value;
  const marks = document.getElementById('marks').value;

  fetch(`/students/${id}`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('[name=csrf-token]').content
    },
    body: JSON.stringify({ student: { name, subject_name, marks } })
  })
  .then(response => response.json())
  .then(student => {
    const row = document.querySelector(`tr[data-id='${student.id}']`);
    if (row) {
      row.querySelector('td:nth-child(1)').innerText = student.name;
      row.querySelector('td:nth-child(2)').innerText = student.subject_name;
      row.querySelector('td:nth-child(3)').innerText = student.marks;
    }
    closeAddStudentModal();
  });
}

window.deleteStudent = function(id) {
  fetch(`/students/${id}`, {
    method: 'DELETE',
    headers: {
      'X-CSRF-Token': document.querySelector('[name=csrf-token]').content
    }
  })
  .then(() => {
    const row = document.querySelector(`tr[data-id='${id}']`);
    row.remove();
  });
}

window.showEditStudentModal = function(id) {
  fetch(`/students/${id}`)
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(student => {
      showAddStudentModal(student);
    })
    .catch(error => {
      console.error('There was a problem with the fetch operation:', error);
    });
}


document.addEventListener('DOMContentLoaded', function() {
    const addStudentModal = document.getElementById('add-student-modal');
    const modalBackdrop = document.getElementById('modal-backdrop');
    const container = document.querySelector('.container');

    function showModal() {
        addStudentModal.style.display = 'block';
        modalBackdrop.style.display = 'block';
        container.classList.add('blur-background');
    }

    function closeAddStudentModal() {
        addStudentModal.style.display = 'none';
        modalBackdrop.style.display = 'none';
        container.classList.remove('blur-background');
    }

    modalBackdrop.addEventListener('click', closeAddStudentModal);

    document.querySelector('.add-popup-btn').addEventListener('click', showModal);

    document.querySelector('.btn-close').addEventListener('click', closeAddStudentModal);
});