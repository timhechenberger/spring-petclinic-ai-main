package org.springframework.samples.petclinic.owner;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/owners/{ownerId}/pets/{petId}")
class VisitController {

	private final OwnerRepository owners;

	VisitController(OwnerRepository owners) {
		this.owners = owners;
	}

	@ModelAttribute("owner")
	Owner findOwner(@PathVariable Integer ownerId) {
		return owners.findById(ownerId)
			.orElseThrow(() -> new IllegalArgumentException("Owner not found " + ownerId));
	}

	@ModelAttribute("pet")
	Pet loadPet(@ModelAttribute Owner owner, @PathVariable Integer petId) {
		Pet p = owner.getPet(petId);
		if (p == null) throw new IllegalArgumentException("Pet not found " + petId);
		return p;
	}

	@ModelAttribute("procedureTypes")
	List<String> procedureTypes() {
		return List.of(
			"Impfung", "Routine", "Notfall", "Operation",
			"Zahnbehandlung", "Blutuntersuchung", "Wundversorgung"
		);
	}

	@InitBinder("visit")
	void initVisitBinder(WebDataBinder binder) {
		binder.setDisallowedFields("id");
	}

	// Timeline-Ansicht (optional)
	@GetMapping("/timeline")
	String timeline(@ModelAttribute Owner owner, @ModelAttribute Pet pet, Model model) {
		model.addAttribute("owner", owner);
		model.addAttribute("pet", pet);
		model.addAttribute("timelineVisits", pet.getTimelineVisits());
		return "pets/timeline";
	}

	// Formular anzeigen
	@GetMapping("/visits/new")
	String initForm(@ModelAttribute Owner owner,
					@ModelAttribute Pet pet,
					Model model) {
		Visit visit = new Visit();
		visit.setDate(LocalDate.now());
		visit.setTime(LocalTime.now());
		model.addAttribute("owner", owner);
		model.addAttribute("pet", pet);
		model.addAttribute("visit", visit);
		return "pets/createOrUpdateVisitForm";
	}

	// Formular speichern
	@PostMapping("/visits/new")
	String processForm(@ModelAttribute Owner owner,
					   @ModelAttribute Pet pet,
					   @Valid @ModelAttribute("visit") Visit visit,
					   BindingResult result,
					   RedirectAttributes redirect,
					   Model model) {
		if (result.hasErrors()) {
			model.addAttribute("owner", owner);
			model.addAttribute("pet", pet);
			return "pets/createOrUpdateVisitForm";
		}

		// Visit dem Pet hinzufügen und Owner speichern (Cascade)
		pet.addTimelineVisit(visit);
		owners.save(owner);

		redirect.addFlashAttribute("message", "Visit hinzugefügt");
		return "redirect:/owners/{ownerId}";
	}
}
