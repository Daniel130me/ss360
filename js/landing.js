(function () {
    "use strict";

    const body = document.body;
    const header = document.querySelector("[data-header]");
    const navToggle = document.querySelector("[data-nav-toggle]");
    const nav = document.querySelector("[data-nav]");
    const year = document.querySelector("[data-year]");
    const parallaxItems = Array.from(document.querySelectorAll("[data-parallax]"));
    const tiltItems = Array.from(document.querySelectorAll("[data-tilt]"));
    const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const desktopTextReveal = window.matchMedia("(min-width: 761px)").matches;
    const pointerMotion = window.matchMedia("(hover: hover) and (pointer: fine)").matches;
    const maxParallaxOffset = 64;
    const scrollParallaxDistance = 180;
    const maxTilt = 8;
    let ticking = false;

    if (year) {
        year.textContent = new Date().getFullYear();
    }

    // Word-level reveal is desktop-only so mobile text keeps natural wrapping.
    const textRevealItems = document.querySelectorAll("[data-reveal-text]");
    if (!reduceMotion && desktopTextReveal) {
        textRevealItems.forEach((item) => {
            const text = item.textContent.trim();
            const words = text.split(/\s+/);
            item.innerHTML = words
                .map((word, idx) => `<span class="reveal-word-parent"><span class="reveal-word-child" style="transition-delay: ${idx * 25}ms">${word}</span></span>`)
                .join(" ");
            item.classList.add("reveal-text-initialized");
        });
    }

    function setHeaderState() {
        if (!header) {
            return;
        }
        header.classList.toggle("is-scrolled", window.scrollY > 24);

        const scrollable = Math.max(1, document.documentElement.scrollHeight - window.innerHeight);
        const progress = Math.min(1, Math.max(0, window.scrollY / scrollable));
        document.documentElement.style.setProperty("--scroll-progress", progress.toFixed(4));
    }

    // Scroll-driven Parallax
    function applyParallax() {
        const viewportHeight = window.innerHeight || 1;

        parallaxItems.forEach((item) => {
            const ySpeed = Number(item.dataset.parallax || 0);
            const xSpeed = Number(item.dataset.parallaxX || 0);
            const rect = item.getBoundingClientRect();
            const progress = (rect.top + rect.height / 2 - viewportHeight / 2) / viewportHeight;
            const yOffset = Math.max(-maxParallaxOffset, Math.min(maxParallaxOffset, progress * ySpeed * -scrollParallaxDistance));
            const xOffset = Math.max(-maxParallaxOffset, Math.min(maxParallaxOffset, progress * xSpeed * scrollParallaxDistance));

            item.style.setProperty("--parallax-y", `${yOffset}px`);
            item.style.setProperty("--parallax-x", `${xOffset}px`);
        });
    }

    function onScroll() {
        if (ticking) {
            return;
        }

        ticking = true;
        window.requestAnimationFrame(() => {
            setHeaderState();

            if (!reduceMotion) {
                applyParallax();
            }

            ticking = false;
        });
    }

    // Mobile Navigation Drawer Toggle
    if (navToggle && nav) {
        navToggle.addEventListener("click", () => {
            const isOpen = body.classList.toggle("nav-open");
            navToggle.setAttribute("aria-expanded", String(isOpen));
        });

        nav.addEventListener("click", (event) => {
            if (event.target instanceof HTMLAnchorElement) {
                body.classList.remove("nav-open");
                navToggle.setAttribute("aria-expanded", "false");
            }
        });
    }

    // 3D Card Hover Tilt Effect
    if (!reduceMotion && pointerMotion) {
        window.addEventListener("pointermove", (event) => {
            document.documentElement.style.setProperty("--cursor-x", `${event.clientX}px`);
            document.documentElement.style.setProperty("--cursor-y", `${event.clientY}px`);
        }, { passive: true });

        tiltItems.forEach((item) => {
            item.addEventListener("pointermove", (event) => {
                const rect = item.getBoundingClientRect();
                const xRatio = (event.clientX - rect.left) / rect.width - 0.5;
                const yRatio = (event.clientY - rect.top) / rect.height - 0.5;

                item.style.setProperty("--tilt-x", `${(-yRatio * maxTilt).toFixed(2)}deg`);
                item.style.setProperty("--tilt-y", `${(xRatio * maxTilt).toFixed(2)}deg`);
            });

            item.addEventListener("pointerleave", () => {
                item.style.setProperty("--tilt-x", "0deg");
                item.style.setProperty("--tilt-y", "0deg");
            });
        });
    }

    // Intersection Observer for scroll-reveal
    if ("IntersectionObserver" in window) {
        const revealObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach((entry) => {
                if (!entry.isIntersecting) {
                    return;
                }

                entry.target.classList.add("is-visible");
                observer.unobserve(entry.target);
            });
        }, {
            rootMargin: "0px 0px -8% 0px",
            threshold: 0.1,
        });

        document.querySelectorAll(".reveal, [data-reveal-text]").forEach((item) => revealObserver.observe(item));
    } else {
        document.querySelectorAll(".reveal, [data-reveal-text]").forEach((item) => item.classList.add("is-visible"));
    }

    // Details Accordion Behavior
    document.querySelectorAll("details").forEach((details) => {
        details.addEventListener("toggle", () => {
            if (!details.open) {
                return;
            }

            document.querySelectorAll("details[open]").forEach((openDetails) => {
                if (openDetails !== details) {
                    openDetails.open = false;
                }
            });
        });
    });

    // Interactive Smooth Mouse Parallax for Hero and Lab visuals
    if (!reduceMotion && pointerMotion) {
        const heroSection = document.querySelector(".hero");
        const labSection = document.querySelector(".intelligence-lab");

        let targetHeroX = 0, targetHeroY = 0;
        let currentHeroX = 0, currentHeroY = 0;

        let targetLabX = 0, targetLabY = 0;
        let currentLabX = 0, currentLabY = 0;

        if (heroSection) {
            heroSection.addEventListener("mousemove", (e) => {
                const rect = heroSection.getBoundingClientRect();
                targetHeroX = (e.clientX - rect.left - rect.width / 2) / (rect.width / 2);
                targetHeroY = (e.clientY - rect.top - rect.height / 2) / (rect.height / 2);
            });
            heroSection.addEventListener("mouseleave", () => {
                targetHeroX = 0;
                targetHeroY = 0;
            });
        }

        if (labSection) {
            labSection.addEventListener("mousemove", (e) => {
                const rect = labSection.getBoundingClientRect();
                targetLabX = (e.clientX - rect.left - rect.width / 2) / (rect.width / 2);
                targetLabY = (e.clientY - rect.top - rect.height / 2) / (rect.height / 2);
            });
            labSection.addEventListener("mouseleave", () => {
                targetLabX = 0;
                targetLabY = 0;
            });
        }

        function updateMouseParallax() {
            // Lerp calculations for ultra-smooth responsiveness
            currentHeroX += (targetHeroX - currentHeroX) * 0.08;
            currentHeroY += (targetHeroY - currentHeroY) * 0.08;

            currentLabX += (targetLabX - currentLabX) * 0.08;
            currentLabY += (targetLabY - currentLabY) * 0.08;

            // Mouse drift is applied through CSS variables so base rotations stay intact.
            const heroDrifters = document.querySelectorAll(".hero__visual > .screen-stack, .hero__visual > .floating-card, .hero__visual > .glass-stat, .hero__visual > .hero-illustration, .hero__visual > .ambient-orb");
            heroDrifters.forEach((item, index) => {
                const speedFactor = (index + 1) * 8;
                const xVal = currentHeroX * speedFactor;
                const yVal = currentHeroY * speedFactor;
                item.style.setProperty("--mouse-x", `${xVal}px`);
                item.style.setProperty("--mouse-y", `${yVal}px`);
            });

            const labDrifters = document.querySelectorAll(".lab-visual > .lab-card");
            labDrifters.forEach((item, index) => {
                const speedFactor = (index + 1) * 6;
                const xVal = currentLabX * speedFactor;
                const yVal = currentLabY * speedFactor;
                item.style.setProperty("--mouse-x", `${xVal}px`);
                item.style.setProperty("--mouse-y", `${yVal}px`);
            });

            requestAnimationFrame(updateMouseParallax);
        }

        updateMouseParallax();
    }

    setHeaderState();

    if (!reduceMotion) {
        applyParallax();
        window.addEventListener("scroll", onScroll, { passive: true });
        window.addEventListener("resize", onScroll);
    } else {
        window.addEventListener("scroll", setHeaderState, { passive: true });
    }
})();
