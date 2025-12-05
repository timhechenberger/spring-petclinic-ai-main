package org.springframework.samples.petclinic.owner;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.*;

@Entity
@Table(name = "appointments",
	indexes = {
		@Index(name = "idx_appt_pet", columnList = "pet_id"),
		@Index(name = "idx_appt_vet", columnList = "vet_id"),
		@Index(name = "idx_appt_start", columnList = "start_time")
	})
public class Appointment {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "pet_id", nullable = false)
	private Pet pet;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "vet_id", nullable = false)
	private org.springframework.samples.petclinic.vet.Vet vet;

	@NotNull
	@FutureOrPresent
	@Column(name = "start_time", nullable = false)
	private LocalDateTime startTime;

	@NotNull
	@Min(5) @Max(480)
	@Column(name = "duration_minutes", nullable = false)
	private Integer durationMinutes = 30;

	@Size(max = 1000)
	@Column(name = "notes", length = 1000)
	private String notes;

	@Enumerated(EnumType.STRING)
	@Column(name = "status", nullable = false, length = 20)
	private Status status = Status.SCHEDULED;

	public enum Status { SCHEDULED, COMPLETED, CANCELED }

	// getters/setters …
	public Integer getId() { return id; }
	public void setId(Integer id) { this.id = id; }

	public Pet getPet() { return pet; }
	public void setPet(Pet pet) { this.pet = pet; }

	public org.springframework.samples.petclinic.vet.Vet getVet() { return vet; }
	public void setVet(org.springframework.samples.petclinic.vet.Vet vet) { this.vet = vet; }

	public LocalDateTime getStartTime() { return startTime; }
	public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

	public Integer getDurationMinutes() { return durationMinutes; }
	public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }

	public String getNotes() { return notes; }
	public void setNotes(String notes) { this.notes = notes; }

	public Status getStatus() { return status; }
	public void setStatus(Status status) { this.status = status; }
}
