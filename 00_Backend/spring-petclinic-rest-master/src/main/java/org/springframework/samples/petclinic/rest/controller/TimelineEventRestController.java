package org.springframework.samples.petclinic.rest.controller;

import java.net.URI;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.samples.petclinic.model.TimelineEvent;
import org.springframework.samples.petclinic.model.TimelineEventType;
import org.springframework.samples.petclinic.service.TimelineEventService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@RestController
@RequestMapping("/api/pets/{petId}/timeline")
public class TimelineEventRestController {

    private final TimelineEventService service;

    public TimelineEventRestController(TimelineEventService service) {
        this.service = service;
    }

    @GetMapping
    public List<TimelineEventDto> getTimeline(@PathVariable int petId) {
        return service.getTimelineForPet(petId).stream().map(TimelineEventRestController::toDto).toList();
    }

    @PostMapping
    public ResponseEntity<TimelineEventDto> create(
        @PathVariable int petId,
        @Valid @RequestBody CreateTimelineEventRequest req,
        UriComponentsBuilder uriBuilder
    ) {
        TimelineEvent e = new TimelineEvent();
        e.setEventDate(req.eventDate);
        e.setType(req.type);
        e.setTitle(req.title);
        e.setDescription(req.description);

        TimelineEvent saved = service.createForPet(petId, e);

        URI location = uriBuilder.path("/api/pets/{petId}/timeline/{eventId}")
            .buildAndExpand(petId, saved.getId())
            .toUri();

        return ResponseEntity.created(location).body(toDto(saved));
    }

    @PutMapping("/{eventId}")
    public TimelineEventDto update(
        @PathVariable int petId,
        @PathVariable int eventId,
        @Valid @RequestBody UpdateTimelineEventRequest req
    ) {
        TimelineEvent patch = new TimelineEvent();
        patch.setEventDate(req.eventDate);
        patch.setType(req.type);
        patch.setTitle(req.title);
        patch.setDescription(req.description);

        return toDto(service.updateForPet(petId, eventId, patch));
    }

    @DeleteMapping("/{eventId}")
    public ResponseEntity<Void> delete(@PathVariable int petId, @PathVariable int eventId) {
        service.deleteForPet(petId, eventId);
        return ResponseEntity.noContent().build();
    }

    private static TimelineEventDto toDto(TimelineEvent e) {
        TimelineEventDto dto = new TimelineEventDto();
        dto.id = e.getId();
        dto.petId = (e.getPet() != null ? e.getPet().getId() : null);
        dto.eventDate = e.getEventDate();
        dto.type = e.getType();
        dto.title = e.getTitle();
        dto.description = e.getDescription();
        dto.createdAt = e.getCreatedAt();
        return dto;
    }

    // ===== DTOs (keine neuen Ordner) =====

    public static class TimelineEventDto {
        public Integer id;
        public Integer petId;
        public LocalDate eventDate;
        public TimelineEventType type;
        public String title;
        public String description;
        public Instant createdAt;
    }

    public static class CreateTimelineEventRequest {
        @NotNull
        public LocalDate eventDate;

        @NotNull
        public TimelineEventType type;

        @NotBlank
        public String title;

        public String description;
    }

    public static class UpdateTimelineEventRequest {
        @NotNull
        public LocalDate eventDate;

        @NotNull
        public TimelineEventType type;

        @NotBlank
        public String title;

        public String description;
    }
}
