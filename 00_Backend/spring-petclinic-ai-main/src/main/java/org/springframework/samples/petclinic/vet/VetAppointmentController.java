package org.springframework.samples.petclinic.vet;

import org.springframework.samples.petclinic.owner.AppointmentRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/vets/{vetId}/appointments")
class VetAppointmentController {

	private final VetRepository vets;
	private final AppointmentRepository appointments;

	VetAppointmentController(VetRepository vets, AppointmentRepository appointments) {
		this.vets = vets;
		this.appointments = appointments;
	}

	@GetMapping
	String listForDay(@PathVariable int vetId,
					  @RequestParam(name = "date", required = false) String date,
					  Model model) {
		LocalDate day = (date == null) ? LocalDate.now() : LocalDate.parse(date);
		LocalDateTime from = day.atStartOfDay();
		LocalDateTime to = day.plusDays(1).atStartOfDay();

		model.addAttribute("vet", vets.findById(vetId));
		model.addAttribute("date", day);
		model.addAttribute("appointments", appointments.findForVetBetween(vetId, from, to));
		return "vets/appointmentsForVet";
	}
}
