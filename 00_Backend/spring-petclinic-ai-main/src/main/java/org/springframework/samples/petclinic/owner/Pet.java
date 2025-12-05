package org.springframework.samples.petclinic.owner;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.samples.petclinic.model.NamedEntity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;

@Entity
@Table(name = "pets")
public class Pet extends NamedEntity {

	@Column(name = "birth_date")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate birthDate;

	@ManyToOne
	@JoinColumn(name = "type_id")
	private PetType type;

	/** Eigentümer – WICHTIG für Owner-Detailseite */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "owner_id", nullable = false)
	private Owner owner;

	/** Visits sind Kind-Entitäten von Pet */
	@OneToMany(mappedBy = "pet", cascade = CascadeType.ALL, orphanRemoval = true)
	@OrderBy("date ASC, time ASC")
	private List<Visit> visits = new ArrayList<>();

	// --- Getter/Setter ---

	public LocalDate getBirthDate() {
		return this.birthDate;
	}

	public void setBirthDate(LocalDate birthDate) {
		this.birthDate = birthDate;
	}

	public PetType getType() {
		return this.type;
	}

	public void setType(PetType type) {
		this.type = type;
	}

	public Owner getOwner() {
		return owner;
	}

	public void setOwner(Owner owner) {
		this.owner = owner;
	}

	public List<Visit> getVisits() {
		return this.visits;
	}

	public void setVisits(List<Visit> visits) {
		this.visits = visits;
	}

	/** Fügt ein Visit korrekt hinzu (setzt Rückreferenz) */
	public void addVisit(Visit visit) {
		if (visit == null) return;
		visit.setPet(this);
		this.visits.add(visit);
	}

	/** Entfernt ein Visit (orphanRemoval greift) */
	public void removeVisit(Visit visit) {
		if (visit == null) return;
		this.visits.remove(visit);
		visit.setPet(null);
	}

	/** Timeline-Ansicht: nach Datum/Zeit absteigend sortiert */
	public List<Visit> getTimelineVisits() {
		return this.visits.stream()
			.sorted(
				Comparator.comparing(Visit::getDate, Comparator.nullsLast(Comparator.naturalOrder()))
					.thenComparing(Visit::getTime, Comparator.nullsLast(Comparator.naturalOrder()))
					.reversed()
			)
			.collect(Collectors.toList());
	}

	/** Alias – führt auf addVisit zusammen */
	public void addTimelineVisit(Visit visit) {
		addVisit(visit);
	}
}
