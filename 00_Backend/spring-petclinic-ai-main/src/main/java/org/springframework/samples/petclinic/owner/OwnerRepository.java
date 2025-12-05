package org.springframework.samples.petclinic.owner;

import jakarta.annotation.Nonnull;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface OwnerRepository extends JpaRepository<Owner, Integer> {

	Page<Owner> findByLastNameStartingWith(String lastName, Pageable pageable);

	Optional<Owner> findById(@Nonnull Integer id);

	// Nur Pets + Type, KEINE visits (verhindert MultipleBagFetchException)
	@EntityGraph(attributePaths = {"pets", "pets.type"})
	@Query("select o from Owner o where o.id = :id")
	Optional<Owner> findByIdWithPets(@Param("id") Integer id);
}
