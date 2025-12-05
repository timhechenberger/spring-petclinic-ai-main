package org.springframework.samples.petclinic.owner;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Controller
@RequestMapping("/owners/{ownerId}/pets/{petId}/appointments")
class AppointmentController {

	private final AppointmentRepository appointments;
	private final OwnerRepository owners;
	private final org.springframework.samples.petclinic.vet.VetRepository vets;

	AppointmentController(AppointmentRepository appointments,
						  OwnerRepository owners,
						  org.springframework.samples.petclinic.vet.VetRepository vets) {
		this.appointments = appointments;
		this.owners = owners;
		this.vets = vets;
	}

	@ModelAttribute("owner")
	Owner loadOwner(@PathVariable("ownerId") Integer ownerId) {
		return owners.findByIdWithPets(ownerId)   // <- richtige Methode
			.orElseThrow(() -> new IllegalArgumentException("Owner not found: " + ownerId));
	}

	@ModelAttribute("pet")
	Pet loadPet(@ModelAttribute("owner") Owner owner,
				@PathVariable("petId") Integer petId) {
		Pet p = owner.getPet(petId);
		if (p == null) {
			throw new IllegalArgumentException("Pet " + petId + " not found for owner " + owner.getId());
		}
		return p;
	}

	@InitBinder("appointment")
	void initBinder(WebDataBinder binder) {
		binder.setDisallowedFields("id");
	}

	@GetMapping
	String list(@ModelAttribute("owner") Owner owner,
				@ModelAttribute("pet") Pet pet,
				Model model) {
		model.addAttribute("owner", owner);
		model.addAttribute("pet", pet);
		model.addAttribute("appointments", appointments.findByPetId(pet.getId()));
		return "owners/appointmentsList";
	}

	@GetMapping("/new")
	String initCreateForm(@ModelAttribute("owner") Owner owner,
						  @ModelAttribute("pet") Pet pet,
						  Model model) {
		Appointment appt = new Appointment();
		appt.setDurationMinutes(30);

		model.addAttribute("owner", owner);
		model.addAttribute("pet", pet);
		model.addAttribute("appointment", appt);
		model.addAttribute("vets", vets.findAll());
		model.addAttribute("defaultDate", LocalDate.now().plusDays(1));
		model.addAttribute("defaultTime", LocalTime.of(10, 0));
		return "owners/createOrUpdateAppointmentForm";
	}

	@PostMapping("/new")
	String processCreate(@ModelAttribute("owner") Owner owner,
						 @ModelAttribute("pet") Pet pet,
						 @Valid @ModelAttribute("appointment") Appointment appointment,
						 BindingResult result,
						 @RequestParam("date") String date,
						 @RequestParam("time") String time,
						 @RequestParam("vetId") Integer vetId,
						 RedirectAttributes redirect,
						 Model model) {

		LocalDate d = LocalDate.parse(date);
		LocalTime t = LocalTime.parse(time);
		appointment.setStartTime(LocalDateTime.of(d, t));
		appointment.setPet(pet);

		var vet = vets.findAll().stream()
			.filter(v -> v.getId().equals(vetId))
			.findFirst()
			.orElse(null);
		if (vet == null) {
			result.rejectValue("vet", "notFound", "Ausgewählter Tierarzt wurde nicht gefunden.");
		} else {
			appointment.setVet(vet);
		}

		if (!result.hasErrors() && appointment.getDurationMinutes() != null && vet != null) {
			LocalDateTime start = appointment.getStartTime();
			LocalDateTime end = start.plusMinutes(appointment.getDurationMinutes());
			if (appointments.overlapsForVet(vetId, start, end)) {
				result.rejectValue("startTime", "overlap",
					"Der Tierarzt ist zu diesem Zeitpunkt bereits gebucht.");
			}
		}

		if (result.hasErrors()) {
			model.addAttribute("owner", owner);
			model.addAttribute("pet", pet);
			model.addAttribute("vets", vets.findAll());
			return "owners/createOrUpdateAppointmentForm";
		}

		appointments.save(appointment);
		redirect.addFlashAttribute("message", "Termin angelegt.");
		return "redirect:/owners/{ownerId}";
	}

	@PostMapping("/{appointmentId}/cancel")
	String cancel(@PathVariable Integer appointmentId, RedirectAttributes redirect) {
		Appointment appt = appointments.findById(appointmentId);
		if (appt != null) {
			appt.setStatus(Appointment.Status.CANCELED);
			appointments.save(appt);
			redirect.addFlashAttribute("message", "Termin storniert.");
		}
		return "redirect:/owners/{ownerId}/pets/{petId}/appointments";
	}

	@GetMapping("/ping")
	@ResponseBody
	String ping(@PathVariable Integer ownerId, @PathVariable Integer petId) {
		return "OK owner=" + ownerId + " pet=" + petId;
	}
}
