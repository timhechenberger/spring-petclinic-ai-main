package org.springframework.samples.petclinic.owner;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository extends Repository<Appointment, Integer> {

	void save(Appointment appointment);

	Appointment findById(Integer id);

	@Query("select a from Appointment a where a.pet.id = :petId order by a.startTime desc")
	List<Appointment> findByPetId(@Param("petId") Integer petId);

	// ✅ Termine eines Vets in Zeitfenster
	@Query("""
         select a
         from Appointment a
         where a.vet.id = :vetId
           and a.startTime >= :from
           and a.startTime < :to
         order by a.startTime
         """)
	List<Appointment> findForVetBetween(@Param("vetId") Integer vetId,
										@Param("from") LocalDateTime from,
										@Param("to") LocalDateTime to);

	// (Dein Overlap-Fix – hier z. B. native MySQL)
	@Query(value = """
      SELECT EXISTS(
        SELECT 1
        FROM appointments a
        WHERE a.vet_id = :vetId
          AND a.start_time < :end
          AND TIMESTAMPADD(MINUTE, a.duration_minutes, a.start_time) > :start
      )
      """, nativeQuery = true)
	boolean overlapsForVet(@Param("vetId") Integer vetId,
						   @Param("start") LocalDateTime start,
						   @Param("end")   LocalDateTime end);

	void deleteById(Integer id);
}
